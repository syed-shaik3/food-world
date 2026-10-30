
package com.tap.daoimpl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.tap.dao.RestaurantDao;
import com.tap.model.Restaurant;
import com.tap.util.DBConnection;

public class RestaurantDaoImpl implements RestaurantDao {

    private static final String INSERT_RESTAURANT =
            "INSERT INTO restaurant "
            + "(name, cuisineType, deliveryTime, address, adminUserId, "
            + "rating, isActive, imagePath) "
            + "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";

    private static final String GET_RESTAURANT =
            "SELECT * FROM restaurant WHERE restaurantId = ?";

    private static final String UPDATE_RESTAURANT =
            "UPDATE restaurant SET name = ?, cuisineType = ?, "
            + "deliveryTime = ?, address = ?, adminUserId = ?, "
            + "rating = ?, isActive = ?, imagePath = ? "
            + "WHERE restaurantId = ?";

    private static final String DELETE_RESTAURANT =
            "DELETE FROM restaurant WHERE restaurantId = ?";

    private static final String GET_ALL_RESTAURANTS =
            "SELECT * FROM restaurant";

    @Override
    public void addRestaurant(Restaurant restaurant) {
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement preparedStatement =
                     connection.prepareStatement(INSERT_RESTAURANT)) {

            preparedStatement.setString(1, restaurant.getName());
            preparedStatement.setString(2, restaurant.getCuisineType());
            preparedStatement.setInt(3, restaurant.getDeliveryTime());
            preparedStatement.setString(4, restaurant.getAddress());

            if (restaurant.getAdminUserId() == 0) {
                preparedStatement.setNull(5, java.sql.Types.INTEGER);
            } else {
                preparedStatement.setInt(5, restaurant.getAdminUserId());
            }

            preparedStatement.setDouble(6, restaurant.getRating());
            preparedStatement.setBoolean(7, restaurant.isActive());
            preparedStatement.setString(8, restaurant.getImagePath());

            preparedStatement.executeUpdate();

        } catch (SQLException exception) {
            throw new RuntimeException(
                    "Failed to add restaurant.", exception);
        }
    }

    @Override
    public Restaurant getRestaurant(int restaurantId) {
        Restaurant restaurant = null;

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement preparedStatement =
                     connection.prepareStatement(GET_RESTAURANT)) {

            preparedStatement.setInt(1, restaurantId);

            try (ResultSet resultSet = preparedStatement.executeQuery()) {
                if (resultSet.next()) {
                    restaurant = mapRestaurant(resultSet);
                }
            }

        } catch (SQLException exception) {
            throw new RuntimeException(
                    "Failed to retrieve restaurant.", exception);
        }

        return restaurant;
    }

    @Override
    public void updateRestaurant(Restaurant restaurant) {
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement preparedStatement =
                     connection.prepareStatement(UPDATE_RESTAURANT)) {

            preparedStatement.setString(1, restaurant.getName());
            preparedStatement.setString(2, restaurant.getCuisineType());
            preparedStatement.setInt(3, restaurant.getDeliveryTime());
            preparedStatement.setString(4, restaurant.getAddress());

            if (restaurant.getAdminUserId() == 0) {
                preparedStatement.setNull(5, java.sql.Types.INTEGER);
            } else {
                preparedStatement.setInt(5, restaurant.getAdminUserId());
            }

            preparedStatement.setDouble(6, restaurant.getRating());
            preparedStatement.setBoolean(7, restaurant.isActive());
            preparedStatement.setString(8, restaurant.getImagePath());
            preparedStatement.setInt(9, restaurant.getRestaurantId());

            preparedStatement.executeUpdate();

        } catch (SQLException exception) {
            throw new RuntimeException(
                    "Failed to update restaurant.", exception);
        }
    }

    @Override
    public void deleteRestaurant(int restaurantId) {
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement preparedStatement =
                     connection.prepareStatement(DELETE_RESTAURANT)) {

            preparedStatement.setInt(1, restaurantId);
            preparedStatement.executeUpdate();

        } catch (SQLException exception) {
            throw new RuntimeException(
                    "Failed to delete restaurant. Related records may exist.",
                    exception);
        }
    }

    @Override
    public List<Restaurant> getAllRestaurants() {
        List<Restaurant> restaurants = new ArrayList<>();

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement preparedStatement =
                     connection.prepareStatement(GET_ALL_RESTAURANTS);
             ResultSet resultSet = preparedStatement.executeQuery()) {

            while (resultSet.next()) {
                restaurants.add(mapRestaurant(resultSet));
            }

        } catch (SQLException exception) {
            throw new RuntimeException(
                    "Failed to retrieve restaurants.", exception);
        }

        return restaurants;
    }

    private Restaurant mapRestaurant(ResultSet resultSet)
            throws SQLException {

        int adminUserId = resultSet.getInt("adminUserId");

        if (resultSet.wasNull()) {
            adminUserId = 0;
        }

        return new Restaurant(
                resultSet.getInt("restaurantId"),
                resultSet.getString("name"),
                resultSet.getString("cuisineType"),
                resultSet.getInt("deliveryTime"),
                resultSet.getString("address"),
                adminUserId,
                resultSet.getDouble("rating"),
                resultSet.getBoolean("isActive"),
                resultSet.getString("imagePath")
        );
    }
}
