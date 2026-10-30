
package com.tap.daoimpl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.tap.dao.MenuDao;
import com.tap.model.Menu;
import com.tap.util.DBConnection;

public class MenuDaoImpl implements MenuDao {

    private static final String INSERT_MENU =
            "INSERT INTO menu "
            + "(restaurantId, item_name, description, price, "
            + "is_available, imagePath) "
            + "VALUES (?, ?, ?, ?, ?, ?)";

    private static final String GET_MENU =
            "SELECT * FROM menu WHERE menuId = ?";

    private static final String UPDATE_MENU =
            "UPDATE menu SET restaurantId = ?, item_name = ?, "
            + "description = ?, price = ?, is_available = ?, "
            + "imagePath = ? WHERE menuId = ?";

    private static final String DELETE_MENU =
            "DELETE FROM menu WHERE menuId = ?";

    private static final String GET_ALL_MENUS =
            "SELECT * FROM menu";

    private static final String GET_MENUS_BY_RESTAURANT_ID =
            "SELECT * FROM menu WHERE restaurantId = ?";

    @Override
    public void addMenu(Menu menu) {

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement preparedStatement =
                     connection.prepareStatement(INSERT_MENU)) {

            preparedStatement.setInt(1, menu.getRestaurantId());
            preparedStatement.setString(2, menu.getItem_name());
            preparedStatement.setString(3, menu.getDescription());
            preparedStatement.setDouble(4, menu.getPrice());
            preparedStatement.setBoolean(5, menu.isIs_available());
            preparedStatement.setString(6, menu.getImagePath());

            preparedStatement.executeUpdate();

        } catch (SQLException exception) {
            throw new RuntimeException("Failed to add menu item.", exception);
        }
    }

    @Override
    public Menu getMenu(int menuId) {

        Menu menu = null;

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement preparedStatement =
                     connection.prepareStatement(GET_MENU)) {

            preparedStatement.setInt(1, menuId);

            try (ResultSet resultSet = preparedStatement.executeQuery()) {

                if (resultSet.next()) {
                    menu = mapMenu(resultSet);
                }
            }

        } catch (SQLException exception) {
            throw new RuntimeException(
                    "Failed to retrieve menu item.", exception);
        }

        return menu;
    }

    @Override
    public void updateMenu(Menu menu) {

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement preparedStatement =
                     connection.prepareStatement(UPDATE_MENU)) {

            preparedStatement.setInt(1, menu.getRestaurantId());
            preparedStatement.setString(2, menu.getItem_name());
            preparedStatement.setString(3, menu.getDescription());
            preparedStatement.setDouble(4, menu.getPrice());
            preparedStatement.setBoolean(5, menu.isIs_available());
            preparedStatement.setString(6, menu.getImagePath());
            preparedStatement.setInt(7, menu.getMenuId());

            preparedStatement.executeUpdate();

        } catch (SQLException exception) {
            throw new RuntimeException(
                    "Failed to update menu item.", exception);
        }
    }

    @Override
    public void deleteMenu(int menuId) {

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement preparedStatement =
                     connection.prepareStatement(DELETE_MENU)) {

            preparedStatement.setInt(1, menuId);
            preparedStatement.executeUpdate();

        } catch (SQLException exception) {
            throw new RuntimeException(
                    "Failed to delete menu item. It may be referenced by an order.",
                    exception);
        }
    }

    @Override
    public List<Menu> getAllMenus() {

        List<Menu> menus = new ArrayList<>();

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement preparedStatement =
                     connection.prepareStatement(GET_ALL_MENUS);
             ResultSet resultSet = preparedStatement.executeQuery()) {

            while (resultSet.next()) {
                menus.add(mapMenu(resultSet));
            }

        } catch (SQLException exception) {
            throw new RuntimeException(
                    "Failed to retrieve menu items.", exception);
        }

        return menus;
    }

    @Override
    public List<Menu> getMenuByRestaurantId(int restaurantId) {

        List<Menu> menus = new ArrayList<>();

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement preparedStatement =
                     connection.prepareStatement(GET_MENUS_BY_RESTAURANT_ID)) {

            preparedStatement.setInt(1, restaurantId);

            try (ResultSet resultSet = preparedStatement.executeQuery()) {

                while (resultSet.next()) {
                    menus.add(mapMenu(resultSet));
                }
            }

        } catch (SQLException exception) {
            throw new RuntimeException(
                    "Failed to retrieve menu items for the restaurant.",
                    exception);
        }

        return menus;
    }

    private Menu mapMenu(ResultSet resultSet) throws SQLException {

        return new Menu(
                resultSet.getInt("menuId"),
                resultSet.getInt("restaurantId"),
                resultSet.getString("item_name"),
                resultSet.getString("description"),
                resultSet.getDouble("price"),
                resultSet.getBoolean("is_available"),
                resultSet.getString("imagePath")
        );
    }
}
