package com.project.platehop.service;

import java.sql.Timestamp;
import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import com.project.platehop.model.Cart;
import com.project.platehop.model.CartItem;
import com.project.platehop.model.Order;
import com.project.platehop.model.OrderItem;
import com.project.platehop.model.User;
import com.project.platehop.repository.OrderItemRepository;
import com.project.platehop.repository.OrderRepository;

@Service
public class OrderService {

    @Autowired
    private OrderRepository orderRepository;

    @Autowired
    private OrderItemRepository orderItemRepository;

    public Order addOrder(Order order) {
        if (order.getOrderDate() == null) {
            order.setOrderDate(new Timestamp(System.currentTimeMillis()));
        }
        if (order.getStatus() == null || order.getStatus().trim().isEmpty()) {
            order.setStatus("pending");
        }
        return orderRepository.save(order);
    }

    @Transactional
    public Order placeOrder(User user, Cart cart, String paymentMethod) {
        if (user == null || cart == null || cart.getItems().isEmpty()) {
            throw new IllegalArgumentException("Cannot place order with empty user or cart");
        }

        if (paymentMethod == null || paymentMethod.trim().isEmpty()) {
            paymentMethod = "cash";
        } else {
            paymentMethod = paymentMethod.trim().toLowerCase();
        }

        // Get restaurant ID from first cart item
        int restaurantId = cart.getItems().values().iterator().next().getRestaurantId();
        double totalAmount = cart.getGrandTotal();

        Order order = new Order();
        order.setUserId(user.getId());
        order.setRestaurantId(restaurantId);
        order.setTotalAmount(totalAmount);
        order.setStatus("pending");
        order.setPaymentMethod(paymentMethod);
        order.setOrderDate(new Timestamp(System.currentTimeMillis()));

        Order savedOrder = orderRepository.save(order);

        for (CartItem item : cart.getItems().values()) {
            OrderItem orderItem = new OrderItem();
            orderItem.setOrderId(savedOrder.getId());
            orderItem.setMenuId(item.getMenuId());
            orderItem.setQuantity(item.getQuantity());
            orderItem.setItemTotal(item.getSubtotal());
            orderItemRepository.save(orderItem);
        }

        cart.clear();
        return savedOrder;
    }

    public List<Order> getAllOrders() {
        return orderRepository.findAll();
    }

    public List<Order> getOrdersByUserId(int userId) {
        return orderRepository.findByUserIdOrderByOrderDateDesc(userId);
    }

    public Order getOrderById(int id) {
        return orderRepository.findById(id).orElse(null);
    }

    public Order updateOrder(Order order) {
        return orderRepository.save(order);
    }

    public void updateOrderStatus(int id, String status) {
        Order order = getOrderById(id);
        if (order != null) {
            order.setStatus(status);
            orderRepository.save(order);
        }
    }

    public void deleteOrder(int id) {
        orderRepository.deleteById(id);
    }
}
