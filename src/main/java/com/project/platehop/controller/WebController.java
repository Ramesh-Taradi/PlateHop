package com.project.platehop.controller;

import java.util.List;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.project.platehop.model.Cart;
import com.project.platehop.model.CartItem;
import com.project.platehop.model.Menu;
import com.project.platehop.model.Order;
import com.project.platehop.model.Restaurant;
import com.project.platehop.model.User;
import com.project.platehop.service.MenuService;
import com.project.platehop.service.OrderService;
import com.project.platehop.service.RestaurantService;
import com.project.platehop.service.UserService;

@Controller
public class WebController {

    @Autowired
    private UserService userService;

    @Autowired
    private RestaurantService restaurantService;

    @Autowired
    private MenuService menuService;

    @Autowired
    private OrderService orderService;

    // Home Page
    @GetMapping({"/", "/index", "/index.jsp", "/home"})
    public String home() {
        return "index";
    }

    // Restaurants Page
    @GetMapping({"/restaurants", "/restaurants.jsp"})
    public String showRestaurants(HttpServletRequest request, Model model) {
        List<Restaurant> allRestaurants = restaurantService.getActiveRestaurants();
        request.setAttribute("allRestaurants", allRestaurants);
        model.addAttribute("allRestaurants", allRestaurants);
        return "restaurants";
    }

    // Menu Page
    @GetMapping({"/Menu", "/menu", "/menu.jsp"})
    public String showMenu(@RequestParam(value = "restaurantId", required = false) Integer restaurantId,
                           HttpServletRequest request, Model model) {
        if (restaurantId == null || restaurantId <= 0) {
            return "redirect:/restaurants";
        }

        Restaurant restaurant = restaurantService.getRestaurantById(restaurantId);
        if (restaurant == null) {
            return "redirect:/restaurants";
        }

        List<Menu> menuList = menuService.getMenusByRestaurant(restaurantId);
        request.setAttribute("restaurant", restaurant);
        request.setAttribute("menuList", menuList);
        model.addAttribute("restaurant", restaurant);
        model.addAttribute("menuList", menuList);

        return "menu";
    }

    // Cart Page (GET)
    @GetMapping({"/cart", "/cart.jsp"})
    public String showCart(HttpSession session, HttpServletRequest request, Model model) {
        User loggedInUser = (User) session.getAttribute("loggedInUser");
        if (loggedInUser == null) {
            return "redirect:/login.jsp";
        }

        Cart cart = (Cart) session.getAttribute("cart");
        if (cart == null) {
            cart = new Cart();
            session.setAttribute("cart", cart);
        }

        request.setAttribute("cart", cart);
        model.addAttribute("cart", cart);
        return "cart";
    }

    // Cart Actions (POST) - CartServlet compatible
    @PostMapping({"/CartServlet", "/cart"})
    public String handleCart(@RequestParam(value = "action", required = false) String action,
                             @RequestParam(value = "menuId", required = false) Integer menuId,
                             @RequestParam(value = "restaurantId", required = false) Integer restaurantId,
                             @RequestParam(value = "quantity", required = false, defaultValue = "1") Integer quantity,
                             HttpSession session, HttpServletRequest request) {

        Cart cart = (Cart) session.getAttribute("cart");
        Integer currentRestaurantId = (Integer) session.getAttribute("restaurantId");

        if (cart == null || currentRestaurantId == null || (restaurantId != null && !currentRestaurantId.equals(restaurantId))) {
            cart = new Cart();
            session.setAttribute("cart", cart);
            if (restaurantId != null) {
                session.setAttribute("restaurantId", restaurantId);
            }
        }

        if ("add".equalsIgnoreCase(action) && menuId != null) {
            Menu menu = menuService.getMenuById(menuId);
            if (menu != null) {
                CartItem item = new CartItem(
                        menu.getMenuId(),
                        menu.getRestaurantId(),
                        menu.getItemName(),
                        menu.getPrice(),
                        quantity != null ? quantity : 1
                );
                cart.addItem(item);
                session.setAttribute("restaurantId", menu.getRestaurantId());
            }
        } else if ("update".equalsIgnoreCase(action) && menuId != null && quantity != null) {
            cart.updateItem(menuId, quantity);
        } else if ("delete".equalsIgnoreCase(action) && menuId != null) {
            cart.removeItem(menuId);
        }

        request.setAttribute("cart", cart);
        return "cart";
    }

    // Checkout Page (GET)
    @GetMapping({"/checkout", "/checkout.jsp"})
    public String showCheckout(HttpSession session, HttpServletRequest request, Model model) {
        User loggedInUser = (User) session.getAttribute("loggedInUser");
        if (loggedInUser == null) {
            return "redirect:/login.jsp";
        }

        Cart cart = (Cart) session.getAttribute("cart");
        if (cart == null || cart.getItems().isEmpty()) {
            return "redirect:/cart.jsp";
        }

        request.setAttribute("cart", cart);
        model.addAttribute("cart", cart);
        return "checkout";
    }

    // Checkout Submission (POST) - CheckoutServlet compatible
    @PostMapping({"/CheckoutServlet", "/checkout"})
    public String processCheckout(@RequestParam(value = "paymentMethod", defaultValue = "cash") String paymentMethod,
                                  HttpSession session, HttpServletRequest request, Model model) {
        User loggedInUser = (User) session.getAttribute("loggedInUser");
        if (loggedInUser == null) {
            return "redirect:/login.jsp";
        }

        Cart cart = (Cart) session.getAttribute("cart");
        if (cart == null || cart.getItems().isEmpty()) {
            return "redirect:/cart.jsp";
        }

        try {
            Order savedOrder = orderService.placeOrder(loggedInUser, cart, paymentMethod);
            request.setAttribute("orderId", savedOrder.getOrderId());
            model.addAttribute("orderId", savedOrder.getOrderId());
            return "order_confirmation";
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "There was an issue processing your order. Please try again.");
            return "checkout";
        }
    }

    // Orders Page (GET)
    @GetMapping({"/orders", "/orders.jsp"})
    public String showOrders(HttpSession session, HttpServletRequest request, Model model) {
        User loggedInUser = (User) session.getAttribute("loggedInUser");
        if (loggedInUser == null) {
            return "redirect:/login.jsp";
        }

        List<Order> orders = orderService.getOrdersByUserId(loggedInUser.getId());
        request.setAttribute("orders", orders);
        model.addAttribute("orders", orders);
        return "orders";
    }

    // Order Confirmation Page (GET)
    @GetMapping({"/order_confirmation", "/order_confirmation.jsp", "/order-confirmation"})
    public String showOrderConfirmation(@RequestParam(value = "orderId", required = false) Integer orderId,
                                        HttpServletRequest request, Model model) {
        if (orderId != null) {
            request.setAttribute("orderId", orderId);
            model.addAttribute("orderId", orderId);
        }
        return "order_confirmation";
    }

    // Profile Page (GET)
    @GetMapping({"/profile", "/profile.jsp"})
    public String showProfile(HttpSession session, HttpServletRequest request, Model model) {
        User loggedInUser = (User) session.getAttribute("loggedInUser");
        if (loggedInUser == null) {
            return "redirect:/login.jsp";
        }

        // Re-fetch user in case updated
        userService.getUserById(loggedInUser.getId()).ifPresent(u -> {
            session.setAttribute("loggedInUser", u);
        });

        List<Order> userOrders = orderService.getOrdersByUserId(loggedInUser.getId());
        request.setAttribute("userOrders", userOrders);
        model.addAttribute("userOrders", userOrders);
        return "profile";
    }

    // Login Page (GET)
    @GetMapping({"/login", "/login.jsp"})
    public String showLogin(@RequestParam(value = "error", required = false) String error,
                            @RequestParam(value = "success", required = false) String success,
                            HttpServletRequest request, Model model) {
        if ("invalid".equals(error)) {
            request.setAttribute("errorMessage", "Invalid email or password. Please try again.");
        }
        return "login";
    }

    // Login Action (POST) - LoginServlet compatible
    @PostMapping({"/LoginServlet", "/login"})
    public String processLogin(@RequestParam("email") String email,
                               @RequestParam("password") String password,
                               HttpSession session, HttpServletRequest request) {
        User user = userService.loginUser(email, password);
        if (user != null) {
            session.setAttribute("loggedInUser", user);
            return "redirect:/restaurants";
        } else {
            request.setAttribute("errorMessage", "Invalid email or password. Please try again.");
            return "login";
        }
    }

    // Register Page (GET)
    @GetMapping({"/register", "/register.jsp"})
    public String showRegister() {
        return "register";
    }

    // Register Action (POST) - RegisterServlet compatible
    @PostMapping({"/RegisterServlet", "/register"})
    public String processRegister(@RequestParam("userName") String userName,
                                  @RequestParam("email") String email,
                                  @RequestParam("password") String password,
                                  @RequestParam(value = "address", required = false) String address,
                                  @RequestParam(value = "role", required = false, defaultValue = "customer") String role,
                                  HttpServletRequest request,
                                  RedirectAttributes redirectAttributes) {
        try {
            if (userService.getUserByEmail(email).isPresent()) {
                request.setAttribute("errorMessage", "An account with this email already exists.");
                return "register";
            }
            userService.registerUser(userName, email, password, address, role);
            return "redirect:/login.jsp?success=registered";
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Registration failed: " + e.getMessage());
            return "register";
        }
    }

    // Logout Action (GET) - LogoutServlet compatible
    @GetMapping({"/LogoutServlet", "/logout"})
    public String processLogout(HttpSession session) {
        if (session != null) {
            session.invalidate();
        }
        return "redirect:/login.jsp?success=logout";
    }
}
