package com.project.platehop.config;

import java.util.Arrays;
import java.util.List;
import org.springframework.boot.CommandLineRunner;
import org.springframework.stereotype.Component;
import com.project.platehop.model.Menu;
import com.project.platehop.model.Restaurant;
import com.project.platehop.model.User;
import com.project.platehop.repository.MenuRepository;
import com.project.platehop.repository.RestaurantRepository;
import com.project.platehop.repository.UserRepository;
import org.mindrot.jbcrypt.BCrypt;

@Component
public class DataInitializer implements CommandLineRunner {

    private final RestaurantRepository restaurantRepo;
    private final MenuRepository menuRepo;
    private final UserRepository userRepo;

    public DataInitializer(RestaurantRepository restaurantRepo, MenuRepository menuRepo, UserRepository userRepo) {
        this.restaurantRepo = restaurantRepo;
        this.menuRepo = menuRepo;
        this.userRepo = userRepo;
    }

    @Override
    public void run(String... args) {
        try {
            seedRestaurantsAndMenus();
        } catch (Exception e) {
            System.err.println("Error seeding restaurants: " + e.getMessage());
            e.printStackTrace();
        }
        try {
            seedUsers();
        } catch (Exception e) {
            System.err.println("Error seeding users: " + e.getMessage());
        }
    }

    private void seedUsers() {
        if (userRepo.count() == 0) {
            User demo = new User();
            demo.setName("Demo User");
            demo.setUserName("demo");
            demo.setEmail("demo@platehop.com");
            demo.setPassword(BCrypt.hashpw("demo123", BCrypt.gensalt()));
            demo.setPhone("9876543210");
            demo.setAddress("123 Foodie Street, Bangalore");
            demo.setRole("Customer");
            userRepo.save(demo);
        }
    }

    private void seedRestaurantsAndMenus() {
        if (restaurantRepo.count() > 0) {
            return;
        }

        Object[][] rawRestaurants = new Object[][] {
            {"The Crimson Canvas", "Italian", 35, "1 Main Street", 4.8, "https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?auto=format&fit=crop&w=800&q=80"},
            {"Sapphire Sushi", "Japanese", 25, "2 Main Street", 4.9, "https://images.unsplash.com/photo-1552566626-52f8b828add9?auto=format&fit=crop&w=800&q=80"},
            {"Emerald Eatery", "Healthy", 20, "3 Main Street", 4.6, "https://images.unsplash.com/photo-1550966871-3ed3cdb5ed0c?auto=format&fit=crop&w=800&q=80"},
            {"Golden Grill", "American", 30, "4 Main Street", 4.5, "https://images.unsplash.com/photo-1555396273-367ea4eb4db5?auto=format&fit=crop&w=800&q=80"},
            {"Ruby Tacos", "Mexican", 25, "5 Main Street", 4.7, "https://images.unsplash.com/photo-1514933651103-005eec06c04b?auto=format&fit=crop&w=800&q=80"},
            {"Amethyst Asian", "Chinese", 40, "6 Main Street", 4.4, "https://images.unsplash.com/photo-1544148103-0773bf10d330?auto=format&fit=crop&w=800&q=80"},
            {"Topaz Thai", "Thai", 35, "7 Main Street", 4.8, "https://images.unsplash.com/photo-1537047902294-62a40c20a6ae?auto=format&fit=crop&w=800&q=80"},
            {"Pearl Pizzeria", "Italian", 30, "8 Main Street", 4.3, "https://images.unsplash.com/photo-1559339352-11d035aa65de?auto=format&fit=crop&w=800&q=80"},
            {"Onyx Oven", "Indian", 45, "9 Main Street", 4.9, "https://images.unsplash.com/photo-1525610553991-2bede1a236e2?auto=format&fit=crop&w=800&q=80"},
            {"Coral Cafe", "Cafe", 15, "10 Main Street", 4.5, "https://images.unsplash.com/photo-1560624052-449f5ddf0c31?auto=format&fit=crop&w=800&q=80"},
            {"Quartz Quesadillas", "Mexican", 20, "11 Main Street", 4.6, "https://images.unsplash.com/photo-1502301103665-0b95cc738daf?auto=format&fit=crop&w=800&q=80"},
            {"Jade Junction", "Asian Fusion", 35, "12 Main Street", 4.7, "https://images.unsplash.com/photo-1514361892635-6b07e31e75f3?auto=format&fit=crop&w=800&q=80"},
            {"Opal Ocean Seafood", "Seafood", 50, "13 Main Street", 4.8, "https://images.unsplash.com/photo-1466978913421-bac2e59216e2?auto=format&fit=crop&w=800&q=80"},
            {"Amber Burgers", "American", 25, "14 Main Street", 4.5, "https://images.unsplash.com/photo-1482049016688-2d3e1b311543?auto=format&fit=crop&w=800&q=80"},
            {"Bronze Bakery", "Bakery", 15, "15 Main Street", 4.9, "https://images.unsplash.com/photo-1414235077428-338989a2e8c0?auto=format&fit=crop&w=800&q=80"},
            {"Cobalt Curries", "Indian", 40, "16 Main Street", 4.7, "https://images.unsplash.com/photo-1424847651672-bf20a4b0982b?auto=format&fit=crop&w=800&q=80"},
            {"Ivory Ice Cream", "Dessert", 10, "17 Main Street", 4.8, "https://images.unsplash.com/photo-1550547660-d9450f859349?auto=format&fit=crop&w=800&q=80"},
            {"Platinum Pasta", "Italian", 35, "18 Main Street", 4.6, "https://images.unsplash.com/photo-1563514258169-2f5f14e5bb00?auto=format&fit=crop&w=800&q=80"},
            {"Obsidian BBQ", "BBQ", 45, "19 Main Street", 4.7, "https://images.unsplash.com/photo-1576867757603-05b134ebc379?auto=format&fit=crop&w=800&q=80"},
            {"Crystal Crepes", "French", 20, "20 Main Street", 4.8, "https://images.unsplash.com/photo-1515669097368-22e68427d265?auto=format&fit=crop&w=800&q=80"}
        };

        Object[][] rawMenus = new Object[][] {
            {"Classic Margherita", "Authentic tomato base, buffalo mozzarella, fresh basil, and extra virgin olive oil.", 12.99, "Mains", "https://images.unsplash.com/photo-1604382355076-af4b0eb60143?auto=format&fit=crop&w=500&q=80"},
            {"Spicy Tuna Roll", "Fresh tuna, spicy sriracha mayo, cucumber, wrapped in seasoned seaweed sushi rice.", 14.50, "Mains", "https://images.unsplash.com/photo-1579871494447-9811cf80d66c?auto=format&fit=crop&w=500&q=80"},
            {"Avocado Salad", "Hass avocado, baby greens, cherry tomatoes, cucumbers, citrus vinaigrette.", 9.99, "Starters", "https://images.unsplash.com/photo-1540420773420-3366772f4999?auto=format&fit=crop&w=500&q=80"},
            {"Double Cheeseburger", "Two flame-grilled beef patties, cheddar cheese, crisp lettuce, secret sauce, brioche bun.", 13.50, "Mains", "https://images.unsplash.com/photo-1568901346375-23c9450c58cd?auto=format&fit=crop&w=500&q=80"},
            {"Chicken Tikka Masala", "Charcoal-grilled spiced chicken chunks simmered in a creamy aromatic tomato sauce.", 16.99, "Mains", "https://images.unsplash.com/photo-1588166524941-3bf61a9c41db?auto=format&fit=crop&w=500&q=80"},
            {"Beef Tacos", "Three warm corn tortillas stuffed with seasoned shredded beef, pico de gallo, and cotija.", 11.99, "Mains", "https://images.unsplash.com/photo-1551504734-5ee1c4a1479b?auto=format&fit=crop&w=500&q=80"},
            {"Pad Thai", "Stir-fried rice noodles with tamarind sauce, tofu, eggs, crushed peanuts, and lime.", 14.00, "Mains", "https://images.unsplash.com/photo-1559847844-5315695dadae?auto=format&fit=crop&w=500&q=80"},
            {"Chocolate Lava Cake", "Warm decadent dark chocolate cake with a rich molten chocolate fudge center.", 7.99, "Dessert", "https://images.unsplash.com/photo-1606313564200-e75d5e30476c?auto=format&fit=crop&w=500&q=80"},
            {"Garlic Bread", "Artisan baguette toasted with roasted garlic, aromatic herbs, and melted mozzarella.", 4.99, "Starters", "https://images.unsplash.com/photo-1573140247632-f8fd74997d5c?auto=format&fit=crop&w=500&q=80"},
            {"Strawberry Cheesecake", "Classic New York-style baked cheesecake topped with fresh strawberry compote.", 6.50, "Dessert", "https://images.unsplash.com/photo-1533134242443-d4fd215305ad?auto=format&fit=crop&w=500&q=80"}
        };

        for (Object[] rData : rawRestaurants) {
            Restaurant r = new Restaurant();
            r.setName((String) rData[0]);
            r.setCuisineType((String) rData[1]);
            r.setDeliveryTime((Integer) rData[2]);
            r.setAddress((String) rData[3]);
            r.setRating((Double) rData[4]);
            r.setIsActive(1);
            r.setImagePath((String) rData[5]);
            r = restaurantRepo.save(r);

            for (Object[] mData : rawMenus) {
                Menu m = new Menu();
                m.setRestaurantId(r.getRestaurantId());
                m.setItemName((String) mData[0]);
                m.setDescription((String) mData[1]);
                m.setPrice((Double) mData[2]);
                m.setCategory((String) mData[3]);
                m.setIsAvailable(1);
                m.setImagePath((String) mData[4]);
                menuRepo.save(m);
            }
        }
    }
}
