package com.project.platehop.repository;

import java.util.List;
import org.springframework.data.jpa.repository.JpaRepository;
import com.project.platehop.model.Order;

public interface OrderRepository extends JpaRepository<Order, Integer> {
    List<Order> findByUserId(int userId);
    List<Order> findByUserIdOrderByOrderDateDesc(int userId);
    List<Order> findByRestaurantId(int restaurantId);
}
