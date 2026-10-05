package com.project.platehop.model;

import java.io.Serializable;
import java.util.HashMap;
import java.util.Map;

public class Cart implements Serializable {
    private static final long serialVersionUID = 1L;

    private Map<Integer, CartItem> items;

    public Cart() {
        this.items = new HashMap<>();
    }

    public Map<Integer, CartItem> getItems() {
        return items;
    }

    public void setItems(Map<Integer, CartItem> items) {
        this.items = items;
    }

    public void addItem(CartItem cartItem) {
        int menuId = cartItem.getMenuId();
        if (items.containsKey(menuId)) {
            CartItem existing = items.get(menuId);
            existing.setQuantity(existing.getQuantity() + cartItem.getQuantity());
        } else {
            items.put(menuId, cartItem);
        }
    }

    public void updateItem(int menuId, int quantity) {
        if (items.containsKey(menuId)) {
            if (quantity <= 0) {
                items.remove(menuId);
            } else {
                items.get(menuId).setQuantity(quantity);
            }
        }
    }

    public void removeItem(int menuId) {
        items.remove(menuId);
    }

    public void clear() {
        items.clear();
    }

    public double getGrandTotal() {
        double total = 0.0;
        for (CartItem item : items.values()) {
            total += item.getSubtotal();
        }
        return total;
    }

    public int getTotalCount() {
        int count = 0;
        for (CartItem item : items.values()) {
            count += item.getQuantity();
        }
        return count;
    }
}
