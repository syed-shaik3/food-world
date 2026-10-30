
package com.tap.daoimpl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.tap.dao.OrderDao;
import com.tap.model.Order;
import com.tap.util.DBConnection;

public class OrderDaoImpl implements OrderDao {

    private static final String INSERT_ORDER =
        "INSERT INTO `Order` " +
        "(userId, restaurantId, orderDate, totalAmount, status, paymentMode, " +
        "deliveryName, deliveryPhone, deliveryAddress, landmark) " +
        "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

    private static final String GET_ORDER =
        "SELECT * FROM `Order` WHERE orderId = ?";

    private static final String UPDATE_ORDER =
        "UPDATE `Order` SET userId = ?, restaurantId = ?, orderDate = ?, " +
        "totalAmount = ?, status = ?, paymentMode = ?, deliveryName = ?, " +
        "deliveryPhone = ?, deliveryAddress = ?, landmark = ? " +
        "WHERE orderId = ?";

    private static final String DELETE_ORDER =
        "DELETE FROM `Order` WHERE orderId = ?";

    private static final String GET_ALL_ORDERS =
        "SELECT * FROM `Order`";

    private static final String GET_ORDERS_BY_USER =
        "SELECT * FROM `Order` WHERE userId = ?";

    private static final String GET_ORDERS_BY_RESTAURANT =
        "SELECT * FROM `Order` WHERE restaurantId = ?";



	@Override
	public int addOrder(Order order) {

		String INSERT_ORDER = "INSERT INTO `Order` "
				+ "(userId, restaurantId, orderDate, totalAmount, status, paymentMode, "
				+ "deliveryName, deliveryPhone, deliveryAddress, landmark) " + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

		try (Connection connection = DBConnection.getConnection();
				PreparedStatement statement = connection.prepareStatement(INSERT_ORDER,
						PreparedStatement.RETURN_GENERATED_KEYS)) {

			// Set order details
			statement.setInt(1, order.getUserId());
			statement.setInt(2, order.getRestaurantId());
			statement.setTimestamp(3, order.getOrderDate());
			statement.setDouble(4, order.getTotalAmount());
			statement.setString(5, order.getStatus());
			statement.setString(6, order.getPaymentMode());

			// Set delivery details
			statement.setString(7, order.getDeliveryName());
			statement.setString(8, order.getDeliveryPhone());
			statement.setString(9, order.getDeliveryAddress());
			statement.setString(10, order.getLandmark());

			// Execute INSERT query
			int rows = statement.executeUpdate();

			// Retrieve generated orderId
			if (rows > 0) {
				try (ResultSet resultSet = statement.getGeneratedKeys()) {
					if (resultSet.next()) {
						int orderId = resultSet.getInt(1);

						// Store generated ID in the Order object
						order.setOrderId(orderId);

						// Return generated orderId
						return orderId;
					}
				}
			}

			throw new SQLException("Order was not inserted or orderId was not generated.");

		} catch (SQLException e) {
			throw new RuntimeException("Failed to add order.", e);
		}
	}



    @Override
    public Order getOrder(int orderId) {
        Order order = null;

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement =
                 connection.prepareStatement(GET_ORDER)) {

            statement.setInt(1, orderId);

            try (ResultSet resultSet = statement.executeQuery()) {
                if (resultSet.next()) {
                    order = mapOrder(resultSet);
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return order;
    }


    @Override
    public void updateOrder(Order order) {
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement =
                 connection.prepareStatement(UPDATE_ORDER)) {

            statement.setInt(1, order.getUserId());
            statement.setInt(2, order.getRestaurantId());
            statement.setTimestamp(3, order.getOrderDate());
            statement.setDouble(4, order.getTotalAmount());
            statement.setString(5, order.getStatus());
            statement.setString(6, order.getPaymentMode());
            statement.setString(7, order.getDeliveryName());
            statement.setString(8, order.getDeliveryPhone());
            statement.setString(9, order.getDeliveryAddress());
            statement.setString(10, order.getLandmark());
            statement.setInt(11, order.getOrderId());

            statement.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }


    @Override
    public void deleteOrder(int orderId) {
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement =
                 connection.prepareStatement(DELETE_ORDER)) {

            statement.setInt(1, orderId);
            statement.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }


    @Override
    public List<Order> getAllOrders() {
        List<Order> orders = new ArrayList<>();

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement =
                 connection.prepareStatement(GET_ALL_ORDERS);
             ResultSet resultSet = statement.executeQuery()) {

            while (resultSet.next()) {
                orders.add(mapOrder(resultSet));
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return orders;
    }


    @Override
    public List<Order> getOrdersByUserId(int userId) {
        List<Order> orders = new ArrayList<>();

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement =
                 connection.prepareStatement(GET_ORDERS_BY_USER)) {

            statement.setInt(1, userId);

            try (ResultSet resultSet = statement.executeQuery()) {
                while (resultSet.next()) {
                    orders.add(mapOrder(resultSet));
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return orders;
    }


    @Override
    public List<Order> getOrdersByRestaurantId(int restaurantId) {
        List<Order> orders = new ArrayList<>();

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement =
                 connection.prepareStatement(GET_ORDERS_BY_RESTAURANT)) {

            statement.setInt(1, restaurantId);

            try (ResultSet resultSet = statement.executeQuery()) {
                while (resultSet.next()) {
                    orders.add(mapOrder(resultSet));
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return orders;
    }


    private Order mapOrder(ResultSet resultSet) throws SQLException {
        Order order = new Order();

        order.setOrderId(resultSet.getInt("orderId"));
        order.setUserId(resultSet.getInt("userId"));
        order.setRestaurantId(resultSet.getInt("restaurantId"));
        order.setOrderDate(resultSet.getTimestamp("orderDate"));
        order.setTotalAmount(resultSet.getDouble("totalAmount"));
        order.setStatus(resultSet.getString("status"));
        order.setPaymentMode(resultSet.getString("paymentMode"));

        order.setDeliveryName(resultSet.getString("deliveryName"));
        order.setDeliveryPhone(resultSet.getString("deliveryPhone"));
        order.setDeliveryAddress(resultSet.getString("deliveryAddress"));
        order.setLandmark(resultSet.getString("landmark"));

        return order;
    }
}
