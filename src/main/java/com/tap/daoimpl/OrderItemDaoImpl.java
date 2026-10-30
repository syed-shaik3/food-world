
package com.tap.daoimpl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.tap.dao.OrderItemDao;
import com.tap.model.OrderItem;
import com.tap.util.DBConnection;

public class OrderItemDaoImpl implements OrderItemDao {

    private static final String INSERT_ORDER_ITEM =
            "INSERT INTO orderItem (orderId, menuId, quantity, itemTotal) "
            + "VALUES (?, ?, ?, ?)";

    private static final String GET_ORDER_ITEM =
            "SELECT * FROM orderItem WHERE orderItemId = ?";

    private static final String UPDATE_ORDER_ITEM =
            "UPDATE orderItem SET orderId = ?, menuId = ?, "
            + "quantity = ?, itemTotal = ? WHERE orderItemId = ?";

    private static final String DELETE_ORDER_ITEM =
            "DELETE FROM orderItem WHERE orderItemId = ?";

    private static final String GET_ALL_ORDER_ITEMS =
            "SELECT * FROM orderItem";

    private static final String GET_ORDER_ITEMS_BY_ORDER_ID =
            "SELECT * FROM orderItem WHERE orderId = ?";

    @Override
    public void addOrderItem(OrderItem orderItem) {

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement preparedStatement =
                     connection.prepareStatement(INSERT_ORDER_ITEM)) {

            preparedStatement.setInt(1, orderItem.getOrderId());
            preparedStatement.setInt(2, orderItem.getMenuId());
            preparedStatement.setInt(3, orderItem.getQuantity());
            preparedStatement.setDouble(4, orderItem.getItemTotal());

            preparedStatement.executeUpdate();

        } catch (SQLException exception) {
            throw new RuntimeException(
                    "Failed to add order item.", exception);
        }
    }

    @Override
    public OrderItem getOrderItem(int orderItemId) {

        OrderItem orderItem = null;

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement preparedStatement =
                     connection.prepareStatement(GET_ORDER_ITEM)) {

            preparedStatement.setInt(1, orderItemId);

            try (ResultSet resultSet = preparedStatement.executeQuery()) {
                if (resultSet.next()) {
                    orderItem = mapOrderItem(resultSet);
                }
            }

        } catch (SQLException exception) {
            throw new RuntimeException(
                    "Failed to retrieve order item.", exception);
        }

        return orderItem;
    }

    @Override
    public void updateOrderItem(OrderItem orderItem) {

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement preparedStatement =
                     connection.prepareStatement(UPDATE_ORDER_ITEM)) {

            preparedStatement.setInt(1, orderItem.getOrderId());
            preparedStatement.setInt(2, orderItem.getMenuId());
            preparedStatement.setInt(3, orderItem.getQuantity());
            preparedStatement.setDouble(4, orderItem.getItemTotal());
            preparedStatement.setInt(5, orderItem.getOrderItemId());

            preparedStatement.executeUpdate();

        } catch (SQLException exception) {
            throw new RuntimeException(
                    "Failed to update order item.", exception);
        }
    }

    @Override
    public void deleteOrderItem(int orderItemId) {

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement preparedStatement =
                     connection.prepareStatement(DELETE_ORDER_ITEM)) {

            preparedStatement.setInt(1, orderItemId);
            preparedStatement.executeUpdate();

        } catch (SQLException exception) {
            throw new RuntimeException(
                    "Failed to delete order item.", exception);
        }
    }

    @Override
    public List<OrderItem> getAllOrderItems() {

        List<OrderItem> orderItems = new ArrayList<>();

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement preparedStatement =
                     connection.prepareStatement(GET_ALL_ORDER_ITEMS);
             ResultSet resultSet = preparedStatement.executeQuery()) {

            while (resultSet.next()) {
                orderItems.add(mapOrderItem(resultSet));
            }

        } catch (SQLException exception) {
            throw new RuntimeException(
                    "Failed to retrieve order items.", exception);
        }

        return orderItems;
    }

    @Override
    public List<OrderItem> getOrderItemsByOrderId(int orderId) {

        List<OrderItem> orderItems = new ArrayList<>();

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement preparedStatement =
                     connection.prepareStatement(GET_ORDER_ITEMS_BY_ORDER_ID)) {

            preparedStatement.setInt(1, orderId);

            try (ResultSet resultSet = preparedStatement.executeQuery()) {
                while (resultSet.next()) {
                    orderItems.add(mapOrderItem(resultSet));
                }
            }

        } catch (SQLException exception) {
            throw new RuntimeException(
                    "Failed to retrieve items for the order.", exception);
        }

        return orderItems;
    }

    private OrderItem mapOrderItem(ResultSet resultSet)
            throws SQLException {

        return new OrderItem(
                resultSet.getInt("orderItemId"),
                resultSet.getInt("orderId"),
                resultSet.getInt("menuId"),
                resultSet.getInt("quantity"),
                resultSet.getDouble("itemTotal")
        );
    }
}
