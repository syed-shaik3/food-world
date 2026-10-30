
package com.tap.controller;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import com.tap.daoimpl.MenuDaoImpl;
import com.tap.daoimpl.OrderDaoImpl;
import com.tap.daoimpl.OrderItemDaoImpl;
import com.tap.daoimpl.RestaurantDaoImpl;
import com.tap.model.Menu;
import com.tap.model.Order;
import com.tap.model.OrderItem;
import com.tap.model.Restaurant;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/orders")
public class OrdersController extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private OrderDaoImpl orderDao;
    private OrderItemDaoImpl orderItemDao;
    private RestaurantDaoImpl restaurantDao;
    private MenuDaoImpl menuDao;

    @Override
    public void init() throws ServletException {
        orderDao = new OrderDaoImpl();
        orderItemDao = new OrderItemDaoImpl();
        restaurantDao = new RestaurantDaoImpl();
        menuDao = new MenuDaoImpl();
    }

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("text/html;charset=UTF-8");

        // Check the existing login session.
        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(
                    request.getContextPath() + "/login.jsp");
            return;
        }

        try {
            // Get the logged-in user's ID from the session.
            int userId = (Integer) session.getAttribute("userId");

            // Retrieve only this user's orders.
            List<Order> orders = orderDao.getOrdersByUserId(userId);

            // Store detailed information for each order.
            List<OrderDetails> orderDetailsList = new ArrayList<>();

            for (Order order : orders) {

                // Retrieve restaurant information.
                Restaurant restaurant =
                        restaurantDao.getRestaurant(
                                order.getRestaurantId());

                // Retrieve items belonging to this order.
                List<OrderItem> orderItems =
                        orderItemDao.getOrderItemsByOrderId(
                                order.getOrderId());

                // Retrieve menu details for each order item.
                List<MenuDetails> menuDetailsList = new ArrayList<>();

                for (OrderItem orderItem : orderItems) {

                    Menu menu = menuDao.getMenu(
                            orderItem.getMenuId());

                    menuDetailsList.add(
                            new MenuDetails(orderItem, menu));
                }

                orderDetailsList.add(
                        new OrderDetails(
                                order,
                                restaurant,
                                menuDetailsList));
            }

            // Send the data to the JSP page.
            request.setAttribute(
                    "orderDetailsList", orderDetailsList);

            request.getRequestDispatcher("/orders.jsp")
                   .forward(request, response);

        } catch (Exception exception) {

            getServletContext().log(
                    "Failed to load order history.", exception);

            response.sendError(
                    HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                    "Unable to load your orders. Please try again later.");
        }
    }

    // Combines an order with its restaurant and menu items.
    public static class OrderDetails {

        private final Order order;
        private final Restaurant restaurant;
        private final List<MenuDetails> menuDetailsList;

        public OrderDetails(Order order,
                            Restaurant restaurant,
                            List<MenuDetails> menuDetailsList) {
            this.order = order;
            this.restaurant = restaurant;
            this.menuDetailsList = menuDetailsList;
        }

        public Order getOrder() {
            return order;
        }

        public Restaurant getRestaurant() {
            return restaurant;
        }

        public List<MenuDetails> getMenuDetailsList() {
            return menuDetailsList;
        }
    }

    // Combines an order item with its menu information.
    public static class MenuDetails {

        private final OrderItem orderItem;
        private final Menu menu;

        public MenuDetails(OrderItem orderItem, Menu menu) {
            this.orderItem = orderItem;
            this.menu = menu;
        }

        public OrderItem getOrderItem() {
            return orderItem;
        }

        public Menu getMenu() {
            return menu;
        }
    }
}
