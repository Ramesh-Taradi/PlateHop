package com.project.platehop.repository;

import java.util.List;
import org.springframework.data.jpa.repository.JpaRepository;
import com.project.platehop.model.OrderItem;

public interface OrderItemRepository extends JpaRepository<OrderItem, Integer> {
    List<OrderItem> findByOrderId(int orderId);
}
