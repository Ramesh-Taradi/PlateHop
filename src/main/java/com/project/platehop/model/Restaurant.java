package com.project.platehop.model;

import java.io.Serializable;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import jakarta.persistence.Transient;

@Entity
@Table(name = "restaurant")
public class Restaurant implements Serializable {
    private static final long serialVersionUID = 1L;

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "RestaurantID")
    private int restaurantId;

    @Column(name = "Name", nullable = false)
    private String name;

    @Column(name = "CuisineType")
    private String cuisineType;

    @Column(name = "DeliveryTime")
    private Integer deliveryTime = 30;

    @Column(name = "Address", columnDefinition = "TEXT")
    private String address;

    @Column(name = "AdminUserID")
    private Integer adminUserId;

    @Column(name = "Rating")
    private Double rating = 4.5;

    @Column(name = "IsActive")
    private Integer isActive = 1;

    @Column(name = "imagePath")
    private String imagePath;

    @Transient
    private String phone;

    public Restaurant() {
    }

    public Restaurant(int restaurantId, String name, String cuisineType, int deliveryTime,
                      String address, int adminUserId, double rating, int isActive, String imagePath) {
        this.restaurantId = restaurantId;
        this.name = name;
        this.cuisineType = cuisineType;
        this.deliveryTime = deliveryTime;
        this.address = address;
        this.adminUserId = adminUserId;
        this.rating = rating;
        this.isActive = isActive;
        this.imagePath = imagePath;
    }

    public Restaurant(String name, String cuisineType, int deliveryTime,
                      String address, int adminUserId, String imagePath) {
        this.name = name;
        this.cuisineType = cuisineType;
        this.deliveryTime = deliveryTime;
        this.address = address;
        this.adminUserId = adminUserId;
        this.imagePath = imagePath;
        this.isActive = 1;
        this.rating = 4.5;
    }

    public int getId() {
        return restaurantId;
    }

    public void setId(int id) {
        this.restaurantId = id;
    }

    public int getRestaurantId() {
        return restaurantId;
    }

    public void setRestaurantId(int restaurantId) {
        this.restaurantId = restaurantId;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getCuisineType() {
        return cuisineType;
    }

    public void setCuisineType(String cuisineType) {
        this.cuisineType = cuisineType;
    }

    public int getDeliveryTime() {
        return deliveryTime != null ? deliveryTime : 30;
    }

    public void setDeliveryTime(int deliveryTime) {
        this.deliveryTime = deliveryTime;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public int getAdminUserId() {
        return adminUserId != null ? adminUserId : 1;
    }

    public void setAdminUserId(int adminUserId) {
        this.adminUserId = adminUserId;
    }

    public double getRating() {
        return rating != null ? rating : 4.5;
    }

    public void setRating(double rating) {
        this.rating = rating;
    }

    public int getIsActive() {
        return isActive != null ? isActive : 1;
    }

    public void setIsActive(int isActive) {
        this.isActive = isActive;
    }

    public String getImagePath() {
        return imagePath;
    }

    public void setImagePath(String imagePath) {
        this.imagePath = imagePath;
    }

    public String getImageUrl() {
        return imagePath;
    }

    public void setImageUrl(String imageUrl) {
        this.imagePath = imageUrl;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    @Override
    public String toString() {
        return "Restaurant [restaurantId=" + restaurantId + ", name=" + name + ", cuisineType=" + cuisineType
                + ", deliveryTime=" + deliveryTime + ", rating=" + rating + ", isActive=" + isActive + "]";
    }
}