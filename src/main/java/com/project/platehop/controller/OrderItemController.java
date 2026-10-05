package com.project.platehop.controller;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import com.project.platehop.model.OrderItem;
import com.project.platehop.service.OrderItemService;

@RestController
@RequestMapping("/api")
public class OrderItemController {

    @Autowired
    private OrderItemService orderItemService;

    @PostMapping("/order-items")
    public OrderItem addOrderItem(@RequestBody OrderItem orderItem) {
        return orderItemService.addOrderItem(orderItem);
    }

    @GetMapping("/order-items")
    public List<OrderItem> getAllOrderItems() {
        return orderItemService.getAllOrderItems();
    }

    @GetMapping("/orders/{orderId}/items")
    public List<OrderItem> getOrderItemsByOrderId(@PathVariable int orderId) {
        return orderItemService.getOrderItemsByOrderId(orderId);
    }

    @GetMapping("/order-items/{id}")
    public OrderItem getOrderItemById(@PathVariable int id) {
        return orderItemService.getOrderItemById(id);
    }

    @PutMapping("/order-items")
    public OrderItem updateOrderItem(@RequestBody OrderItem orderItem) {
        return orderItemService.updateOrderItem(orderItem);
    }

    @DeleteMapping("/order-item/{id}")
    public void deleteOrderItem(@PathVariable int id) {
        orderItemService.deleteOrderItem(id);
    }
}
