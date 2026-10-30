package com.tap.dao;

import com.tap.model.Menu;
import java.util.List;

public interface MenuDao {

    void addMenu(Menu menu);

    Menu getMenu(int menuId);

    void updateMenu(Menu menu);

    void deleteMenu(int menuId);

    List<Menu> getAllMenus();

    List<Menu> getMenuByRestaurantId(int restaurantId);
}