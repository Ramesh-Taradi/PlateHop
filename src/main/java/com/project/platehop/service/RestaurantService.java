package com.project.platehop.service;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.project.platehop.model.Restaurant;
import com.project.platehop.repository.RestaurantRepository;

@Service
public class RestaurantService {

    @Autowired
    private RestaurantRepository restaurantRepository;

    public Restaurant addRestaurant(Restaurant restaurant) {
        return restaurantRepository.save(restaurant);
    }

    public List<Restaurant> getAllRestaurants() {
        return restaurantRepository.findAll();
    }

    public List<Restaurant> getActiveRestaurants() {
        List<Restaurant> active = restaurantRepository.findByIsActive(1);
        if (active == null || active.isEmpty()) {
            return restaurantRepository.findAll();
        }
        return active;
    }

    public Restaurant getRestaurantById(int id) {
        return restaurantRepository.findById(id).orElse(null);
    }

    public List<Restaurant> searchByCuisine(String cuisine) {
        return restaurantRepository.findByCuisineTypeContainingIgnoreCase(cuisine);
    }

    public Restaurant updateRestaurant(Restaurant restaurant) {
        return restaurantRepository.save(restaurant);
    }

    public void deleteRestaurant(int id) {
        restaurantRepository.deleteById(id);
    }
}
