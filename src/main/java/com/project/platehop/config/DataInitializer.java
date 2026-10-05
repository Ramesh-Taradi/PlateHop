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
            seedUsers();
            seedRestaurantsAndMenus();
        } catch (Exception e) {
            System.err.println("DataInitializer error (safe to ignore if data exists): " + e.getMessage());
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

        // Restaurant 1: Spice Symphony
        Restaurant r1 = new Restaurant();
        r1.setName("Spice Symphony");
        r1.setCuisineType("North Indian, Mughlai");
        r1.setDeliveryTime(25);
        r1.setAddress("MG Road, Bangalore");
        r1.setRating(4.8);
        r1.setIsActive(1);
        r1.setImagePath("https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?auto=format&fit=crop&w=600&q=80");
        r1 = restaurantRepo.save(r1);

        addMenuItem(r1.getRestaurantId(), "Butter Chicken", "Tender chicken simmered in a rich tomato and butter gravy.", 320.0, "Mains", "https://images.unsplash.com/photo-1588166524941-3bf61a9c41db?auto=format&fit=crop&w=500&q=80");
        addMenuItem(r1.getRestaurantId(), "Paneer Tikka", "Char-grilled cottage cheese cubes marinated in fragrant tandoori spices.", 240.0, "Starters", "https://images.unsplash.com/photo-1567620905732-2d1ec7ab7445?auto=format&fit=crop&w=500&q=80");
        addMenuItem(r1.getRestaurantId(), "Garlic Naan", "Freshly baked clay-oven leavened bread brushed with garlic butter.", 60.0, "Sides", "https://images.unsplash.com/photo-1601050690597-df0568f70950?auto=format&fit=crop&w=500&q=80");
        addMenuItem(r1.getRestaurantId(), "Gulab Jamun", "Soft warm dumplings soaked in cardamom saffron syrup.", 90.0, "Desserts", "https://images.unsplash.com/photo-1541781774459-bb2af2f05b55?auto=format&fit=crop&w=500&q=80");
        addMenuItem(r1.getRestaurantId(), "Mango Lassi", "Traditional creamy yogurt drink blended with ripe Alphonso mangoes.", 110.0, "Beverages", "https://images.unsplash.com/photo-1525385133512-2f3bdd039054?auto=format&fit=crop&w=500&q=80");

        // Restaurant 2: Pizza Bella
        Restaurant r2 = new Restaurant();
        r2.setName("Pizza Bella");
        r2.setCuisineType("Italian, Pizzas, Pasta");
        r2.setDeliveryTime(30);
        r2.setAddress("Indiranagar, Bangalore");
        r2.setRating(4.6);
        r2.setIsActive(1);
        r2.setImagePath("https://images.unsplash.com/photo-1555396273-367ea4eb4db5?auto=format&fit=crop&w=600&q=80");
        r2 = restaurantRepo.save(r2);

        addMenuItem(r2.getRestaurantId(), "Margherita Gourmet", "San Marzano tomatoes, fresh buffalo mozzarella, and fragrant basil.", 350.0, "Mains", "https://images.unsplash.com/photo-1604382355076-af4b0eb60143?auto=format&fit=crop&w=500&q=80");
        addMenuItem(r2.getRestaurantId(), "Truffle Mushroom Pasta", "Fettuccine tossed in a wild mushroom creamy truffle emulsion.", 380.0, "Mains", "https://images.unsplash.com/photo-1621996346565-e3d5d6281724?auto=format&fit=crop&w=500&q=80");
        addMenuItem(r2.getRestaurantId(), "Bruschetta Trio", "Crispy artisan sourdough topped with vine tomatoes, basil and olive oil.", 190.0, "Starters", "https://images.unsplash.com/photo-1572695157366-5e585ab2b69f?auto=format&fit=crop&w=500&q=80");
        addMenuItem(r2.getRestaurantId(), "Classic Tiramisu", "Espresso-soaked ladyfingers layered with whipped mascarpone cream.", 220.0, "Desserts", "https://images.unsplash.com/photo-1571877227200-a0d98ea607e9?auto=format&fit=crop&w=500&q=80");

        // Restaurant 3: Burger Bistro
        Restaurant r3 = new Restaurant();
        r3.setName("Burger Bistro");
        r3.setCuisineType("American, Burgers, Shakes");
        r3.setDeliveryTime(20);
        r3.setAddress("Koramangala, Bangalore");
        r3.setRating(4.7);
        r3.setIsActive(1);
        r3.setImagePath("https://images.unsplash.com/photo-1568901346375-23c9450c58cd?auto=format&fit=crop&w=600&q=80");
        r3 = restaurantRepo.save(r3);

        addMenuItem(r3.getRestaurantId(), "The Signature Smash Burger", "Double smashed beef/chicken patty, aged cheddar, caramelized onions, house sauce.", 280.0, "Mains", "https://images.unsplash.com/photo-1568901346375-23c9450c58cd?auto=format&fit=crop&w=500&q=80");
        addMenuItem(r3.getRestaurantId(), "Loaded Crispy Fries", "Skin-on fries tossed in smoked paprika, topped with cheese sauce and jalapenos.", 160.0, "Sides", "https://images.unsplash.com/photo-1573080496219-bb080dd4f877?auto=format&fit=crop&w=500&q=80");
        addMenuItem(r3.getRestaurantId(), "Belgian Chocolate Shake", "Thick chilled shake blended with dark chocolate and ice cream.", 150.0, "Beverages", "https://images.unsplash.com/photo-1572490122747-3968b75cc699?auto=format&fit=crop&w=500&q=80");

        // Restaurant 4: Tokyo Bites
        Restaurant r4 = new Restaurant();
        r4.setName("Tokyo Bites");
        r4.setCuisineType("Japanese, Sushi, Asian");
        r4.setDeliveryTime(35);
        r4.setAddress("Whitefield, Bangalore");
        r4.setRating(4.9);
        r4.setIsActive(1);
        r4.setImagePath("https://images.unsplash.com/photo-1579871494447-9811cf80d66c?auto=format&fit=crop&w=600&q=80");
        r4 = restaurantRepo.save(r4);

        addMenuItem(r4.getRestaurantId(), "Salmon Nigiri Platter", "Fresh salmon over seasoned sushi rice with wasabi and pickled ginger.", 450.0, "Mains", "https://images.unsplash.com/photo-1579871494447-9811cf80d66c?auto=format&fit=crop&w=500&q=80");
        addMenuItem(r4.getRestaurantId(), "Crispy Prawn Tempura", "Lightly battered golden prawns served with tentsuyu dipping sauce.", 320.0, "Starters", "https://images.unsplash.com/photo-1615361200141-f45040f367be?auto=format&fit=crop&w=500&q=80");

        // Restaurant 5: Sweet Escapes
        Restaurant r5 = new Restaurant();
        r5.setName("Sweet Escapes");
        r5.setCuisineType("Bakery, Desserts, Cafe");
        r5.setDeliveryTime(18);
        r5.setAddress("Jayanagar, Bangalore");
        r5.setRating(4.8);
        r5.setIsActive(1);
        r5.setImagePath("https://images.unsplash.com/photo-1509440159596-0249088772ff?auto=format&fit=crop&w=600&q=80");
        r5 = restaurantRepo.save(r5);

        addMenuItem(r5.getRestaurantId(), "Molten Choco Lava Cake", "Warm chocolate cake with an oozing liquid chocolate center.", 180.0, "Desserts", "https://images.unsplash.com/photo-1606313564200-e75d5e30476c?auto=format&fit=crop&w=500&q=80");
        addMenuItem(r5.getRestaurantId(), "Cold Brew Hazelnut", "Slow-steeped artisan coffee poured over hazelnut cream and ice.", 140.0, "Beverages", "https://images.unsplash.com/photo-1517701550927-30cf4ba1dba5?auto=format&fit=crop&w=500&q=80");
    }

    private void addMenuItem(int restId, String name, String desc, double price, String category, String img) {
        Menu m = new Menu();
        m.setRestaurantId(restId);
        m.setItemName(name);
        m.setDescription(desc);
        m.setPrice(price);
        m.setCategory(category);
        m.setIsAvailable(1);
        m.setImagePath(img);
        menuRepo.save(m);
    }
}
