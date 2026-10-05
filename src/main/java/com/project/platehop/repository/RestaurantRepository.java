package com.project.platehop.repository;

import java.util.List;
import org.springframework.data.jpa.repository.JpaRepository;
import com.project.platehop.model.Restaurant;

public interface RestaurantRepository extends JpaRepository<Restaurant, Integer> {
    List<Restaurant> findByIsActive(Integer isActive);
    List<Restaurant> findByCuisineTypeContainingIgnoreCase(String cuisineType);
}
