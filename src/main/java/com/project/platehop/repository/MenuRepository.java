package com.project.platehop.repository;

import java.util.List;
import org.springframework.data.jpa.repository.JpaRepository;
import com.project.platehop.model.Menu;

public interface MenuRepository extends JpaRepository<Menu, Integer> {
    List<Menu> findByRestaurantId(int restaurantId);
    List<Menu> findByRestaurantIdAndIsAvailable(int restaurantId, int isAvailable);
    List<Menu> findByRestaurantIdAndCategory(int restaurantId, String category);
}
