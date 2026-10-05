package com.project.platehop.model;

import java.io.Serializable;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.FetchType;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;

@Entity
@Table(name = "ordertable")
@JsonIgnoreProperties({"hibernateLazyInitializer", "handler"})
public class Order implements Serializable {
    private static final long serialVersionUID = 1L;

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "OrderID")
    private int orderId;

    @Column(name = "UserID", nullable = false)
    private int userId;

    @Column(name = "RestaurantID", nullable = false)
    private int restaurantId;

    @Column(name = "OrderDate")
    private Timestamp orderDate;

    @Column(name = "TotalAmount", nullable = false)
    private double totalAmount;

    @Column(name = "Status")
    private String status = "pending";

    @Column(name = "PaymentMethod", nullable = false)
    private String paymentMethod = "cash";

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "UserID", insertable = false, updatable = false)
    private User user;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "RestaurantID", insertable = false, updatable = false)
    private Restaurant restaurant;

    public Order() {
    }

    public Order(int orderId, int userId, int restaurantId, Timestamp orderDate,
                 double totalAmount, String status, String paymentMethod) {
        this.orderId = orderId;
        this.userId = userId;
        this.restaurantId = restaurantId;
        this.orderDate = orderDate;
        this.totalAmount = totalAmount;
        this.status = status;
        this.paymentMethod = paymentMethod;
    }

    public Order(int userId, int restaurantId, double totalAmount, String status, String paymentMethod) {
        this.userId = userId;
        this.restaurantId = restaurantId;
        this.totalAmount = totalAmount;
        this.status = status;
        this.paymentMethod = paymentMethod;
        this.orderDate = new Timestamp(System.currentTimeMillis());
    }

    public int getId() {
        return orderId;
    }

    public void setId(int id) {
        this.orderId = id;
    }

    public int getOrderId() {
        return orderId;
    }

    public void setOrderId(int orderId) {
        this.orderId = orderId;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public int getRestaurantId() {
        return restaurantId;
    }

    public void setRestaurantId(int restaurantId) {
        this.restaurantId = restaurantId;
    }

    public Timestamp getOrderDate() {
        return orderDate;
    }

    public void setOrderDate(Timestamp orderDate) {
        this.orderDate = orderDate;
    }

    public void setOrderDate(LocalDateTime ldt) {
        if (ldt != null) {
            this.orderDate = Timestamp.valueOf(ldt);
        }
    }

    public double getTotalAmount() {
        return totalAmount;
    }

    public void setTotalAmount(double totalAmount) {
        this.totalAmount = totalAmount;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getPaymentMethod() {
        return paymentMethod;
    }

    public void setPaymentMethod(String paymentMethod) {
        this.paymentMethod = paymentMethod;
    }

    public User getUser() {
        return user;
    }

    public void setUser(User user) {
        this.user = user;
        if (user != null) {
            this.userId = user.getId();
        }
    }

    public Restaurant getRestaurant() {
        return restaurant;
    }

    public void setRestaurant(Restaurant restaurant) {
        this.restaurant = restaurant;
        if (restaurant != null) {
            this.restaurantId = restaurant.getId();
        }
    }

    @Override
    public String toString() {
        return "Order [orderId=" + orderId + ", userId=" + userId + ", restaurantId=" + restaurantId
                + ", totalAmount=" + totalAmount + ", status=" + status + ", paymentMethod=" + paymentMethod + "]";
    }
}