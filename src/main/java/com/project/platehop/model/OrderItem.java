package com.project.platehop.model;

import java.io.Serializable;
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
@Table(name = "orderitem")
@JsonIgnoreProperties({"hibernateLazyInitializer", "handler"})
public class OrderItem implements Serializable {
    private static final long serialVersionUID = 1L;

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "OrderItemID")
    private int orderItemId;

    @Column(name = "OrderID", nullable = false)
    private int orderId;

    @Column(name = "MenuID", nullable = false)
    private int menuId;

    @Column(name = "Quantity", nullable = false)
    private int quantity = 1;

    @Column(name = "ItemTotal", nullable = false)
    private double itemTotal;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "OrderID", insertable = false, updatable = false)
    private Order order;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "MenuID", insertable = false, updatable = false)
    private Menu menu;

    public OrderItem() {
    }

    public OrderItem(int orderItemId, int orderId, int menuId, int quantity, double itemTotal) {
        this.orderItemId = orderItemId;
        this.orderId = orderId;
        this.menuId = menuId;
        this.quantity = quantity;
        this.itemTotal = itemTotal;
    }

    public OrderItem(int orderId, int menuId, int quantity, double itemTotal) {
        this.orderId = orderId;
        this.menuId = menuId;
        this.quantity = quantity;
        this.itemTotal = itemTotal;
    }

    public int getId() {
        return orderItemId;
    }

    public void setId(int id) {
        this.orderItemId = id;
    }

    public int getOrderItemId() {
        return orderItemId;
    }

    public void setOrderItemId(int orderItemId) {
        this.orderItemId = orderItemId;
    }

    public int getOrderId() {
        return orderId;
    }

    public void setOrderId(int orderId) {
        this.orderId = orderId;
    }

    public int getMenuId() {
        return menuId;
    }

    public void setMenuId(int menuId) {
        this.menuId = menuId;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public double getItemTotal() {
        return itemTotal;
    }

    public void setItemTotal(double itemTotal) {
        this.itemTotal = itemTotal;
    }

    public double getPrice() {
        return quantity > 0 ? (itemTotal / quantity) : itemTotal;
    }

    public void setPrice(double price) {
        this.itemTotal = price * (quantity > 0 ? quantity : 1);
    }

    public Order getOrder() {
        return order;
    }

    public void setOrder(Order order) {
        this.order = order;
        if (order != null) {
            this.orderId = order.getId();
        }
    }

    public Menu getMenu() {
        return menu;
    }

    public void setMenu(Menu menu) {
        this.menu = menu;
        if (menu != null) {
            this.menuId = menu.getId();
        }
    }

    @Override
    public String toString() {
        return "OrderItem [orderItemId=" + orderItemId + ", orderId=" + orderId + ", menuId=" + menuId
                + ", quantity=" + quantity + ", itemTotal=" + itemTotal + "]";
    }
}