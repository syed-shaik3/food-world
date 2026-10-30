package com.tap.model;

public class Menu {

    private int menuId;
    private int restaurantId;
    private String item_name;
    private String description;
    private double price;
    private boolean is_available;
    private String imagePath;

    public Menu() {

    }

    public Menu(int menuId, int restaurantId, String item_name,
                String description, double price,
                boolean is_available, String imagePath) {
        this.menuId = menuId;
        this.restaurantId = restaurantId;
        this.item_name = item_name;
        this.description = description;
        this.price = price;
        this.is_available = is_available;
        this.imagePath = imagePath;
    }

    public int getMenuId() {
        return menuId;
    }

    public void setMenuId(int menuId) {
        this.menuId = menuId;
    }

    public int getRestaurantId() {
        return restaurantId;
    }

    public void setRestaurantId(int restaurantId) {
        this.restaurantId = restaurantId;
    }

    public String getItem_name() {
        return item_name;
    }

    public void setItem_name(String item_name) {
        this.item_name = item_name;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public double getPrice() {
        return price;
    }

    public void setPrice(double price) {
        this.price = price;
    }

    public boolean isIs_available() {
        return is_available;
    }

    public void setIs_available(boolean is_available) {
        this.is_available = is_available;
    }

    public String getImagePath() {
        return imagePath;
    }

    public void setImagePath(String imagePath) {
        this.imagePath = imagePath;
    }

    @Override
    public String toString() {
        return "Menu [menuId=" + menuId
                + ", restaurantId=" + restaurantId
                + ", item_name=" + item_name
                + ", description=" + description
                + ", price=" + price
                + ", is_available=" + is_available
                + ", imagePath=" + imagePath + "]";
    }
}