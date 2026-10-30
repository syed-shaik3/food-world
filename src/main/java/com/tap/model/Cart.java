
package com.tap.model;

import java.util.Collection;
import java.util.LinkedHashMap;
import java.util.Map;

public class Cart {

    private Map<Integer, CartItem> items;
    private int restaurantId;

    public Cart() {
        items = new LinkedHashMap<>();
        restaurantId = 0;
    }

    // Add item to cart
    public boolean addItem(Menu menu) {

        // First item decides which restaurant this cart belongs to
        if (items.isEmpty()) {
            restaurantId = menu.getRestaurantId();
        }

        // Do not allow items from another restaurant
        if (restaurantId != menu.getRestaurantId()) {
            return false;
        }

        int menuId = menu.getMenuId();

        // If item already exists, increase quantity
        if (items.containsKey(menuId)) {

            CartItem existingItem = items.get(menuId);

            existingItem.setQuantity(
                existingItem.getQuantity() + 1
            );

        } else {

            CartItem cartItem = new CartItem(menu, 1);
            items.put(menuId, cartItem);
        }

        return true;
    }

    // Update item quantity
    public void updateQuantity(int menuId, int quantity) {

        if (items.containsKey(menuId)) {

            if (quantity <= 0) {
                removeItem(menuId);
            } else {
                CartItem item = items.get(menuId);
                item.setQuantity(quantity);
            }
        }
    }

    // Remove item from cart
    public void removeItem(int menuId) {
        items.remove(menuId);

        // Reset restaurant when cart becomes empty
        if (items.isEmpty()) {
            restaurantId = 0;
        }
    }

    // Get all cart items
    public Collection<CartItem> getItems() {
        return items.values();
    }

    // Calculate complete cart total
    public double getTotalAmount() {

        double total = 0;

        for (CartItem item : items.values()) {
            total += item.getSubtotal();
        }

        return total;
    }

    // Get restaurant to which this cart belongs
    public int getRestaurantId() {
        return restaurantId;
    }

    // Check whether cart is empty
    public boolean isEmpty() {
        return items.isEmpty();
    }

    // Remove everything from cart
    public void clear() {
        items.clear();
        restaurantId = 0;
    }
}
