 <%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.sql.Timestamp" %>
<%@ page import="java.util.Locale" %>
<%@ page import="com.tap.controller.OrdersController.OrderDetails" %>
<%@ page import="com.tap.controller.OrdersController.MenuDetails" %>
<%@ page import="com.tap.model.Order" %>
<%@ page import="com.tap.model.OrderItem" %>
<%@ page import="com.tap.model.Restaurant" %>
<%@ page import="com.tap.model.Menu" %>

<%
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);

    String contextPath = request.getContextPath();

    if (session.getAttribute("userId") == null) {
        response.sendRedirect(contextPath + "/login.jsp");
        return;
    }

    List<OrderDetails> orderDetailsList =
        (List<OrderDetails>) request.getAttribute("orderDetailsList");

    SimpleDateFormat dateFormat =
        new SimpleDateFormat("dd MMM yyyy, hh:mm a");

    // Escape text before displaying database values in HTML.
    java.util.function.Function<Object, String> escapeHtml = value -> {
        if (value == null) {
            return "";
        }

        return value.toString()
            .replace("&", "&amp;")
            .replace("<", "&lt;")
            .replace(">", "&gt;")
            .replace("\"", "&quot;")
            .replace("'", "&#39;");
    };

    // Use the same image path conventions as restaurant.jsp and menu.jsp.
    java.util.function.Function<String, String> imageUrl = path -> {
        if (path == null || path.trim().isEmpty()) {
            return "";
        }

        return contextPath + "/" + path.trim().replaceFirst("^/+", "");
    };

    int orderCount = orderDetailsList == null ? 0 : orderDetailsList.size();
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Orders | FoodWorld</title>

    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        :root {
            --page-bg: #f8f3ef;
            --primary: #f4512a;
            --primary-dark: #d9401d;
            --text-dark: #332923;
            --text-muted: #81756e;
            --border: #e9e0d9;
            --shadow: #ded8d3;
        }

        body {
            font-family: Arial, Helvetica, sans-serif;
            background: var(--page-bg);
            color: var(--text-dark);
            min-height: 100vh;
            display: flex;
            flex-direction: column;
        }

        a {
            text-decoration: none;
            color: inherit;
        }

        /* Navigation */
        .navbar {
            width: 94%;
            min-height: 78px;
            margin: 0 auto;
            padding: 10px 28px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 20px;
            background: rgba(255, 255, 255, 0.97);
            border-radius: 0 0 24px 24px;
            box-shadow: 0 8px 25px rgba(80, 50, 30, 0.07);
            position: sticky;
            top: 0;
            z-index: 100;
        }

        .logo {
            display: flex;
            align-items: center;
            gap: 10px;
            flex-shrink: 0;
        }

        .logo-image {
            width: 58px;
            height: 52px;
            object-fit: contain;
        }

        .app-name {
            font-size: 27px;
            font-weight: 800;
            color: var(--text-dark);
            white-space: nowrap;
            letter-spacing: -0.8px;
        }

        .app-name span {
            color: var(--primary);
        }

        .nav-actions {
            display: flex;
            align-items: center;
            justify-content: flex-end;
            flex-wrap: wrap;
            gap: 10px;
        }

        .nav-button {
            display: inline-flex;
            justify-content: center;
            align-items: center;
            padding: 12px 17px;
            min-height: 44px;
            border-radius: 25px;
            border: 1px solid #f0eeec;
            background: #faf9f8;
            color: #38302c;
            font-size: 14px;
            font-weight: 700;
            white-space: nowrap;
            box-shadow: 4px 4px 10px rgba(0, 0, 0, 0.05),
                        -4px -4px 10px #ffffff;
            transition: 0.25s ease;
        }

        .nav-button:hover,
        .nav-button.active {
            background: #fff0e9;
            color: #e94727;
            border-color: #ffded1;
            transform: translateY(-1px);
        }

        /* Page heading */
        .page-container {
            width: 90%;
            max-width: 1120px;
            margin: 40px auto 65px;
            flex: 1;
        }

        .page-heading {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 20px;
            flex-wrap: wrap;
            margin-bottom: 30px;
        }

        .heading-text h1 {
            font-size: clamp(28px, 4vw, 36px);
            margin-bottom: 9px;
            letter-spacing: -0.8px;
        }

        .heading-text p {
            color: var(--text-muted);
            font-size: 15px;
            line-height: 1.7;
        }

        .order-count {
            padding: 13px 20px;
            border-radius: 15px;
            color: var(--primary);
            font-size: 14px;
            font-weight: 800;
            background: var(--page-bg);
            box-shadow: 5px 5px 10px var(--shadow),
                        -5px -5px 10px #ffffff;
        }

        /* Order card */
        .order-card {
            background: var(--page-bg);
            border-radius: 22px;
            padding: 25px;
            margin-bottom: 28px;
            box-shadow: 8px 8px 18px var(--shadow),
                        -8px -8px 18px #ffffff;
            transition: transform 0.25s ease;
        }

        .order-card:hover {
            transform: translateY(-2px);
        }

        .order-header {
            display: flex;
            align-items: flex-start;
            justify-content: space-between;
            gap: 18px;
            flex-wrap: wrap;
            padding-bottom: 20px;
            border-bottom: 1px solid var(--border);
        }

        .order-number {
            font-size: 19px;
            font-weight: 800;
            margin-bottom: 8px;
        }

        .order-date {
            color: var(--text-muted);
            font-size: 13px;
            line-height: 1.6;
        }

        .status-badge {
            display: inline-block;
            padding: 9px 15px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 800;
            letter-spacing: 0.4px;
            background: var(--page-bg);
            box-shadow: inset 3px 3px 6px var(--shadow),
                        inset -3px -3px 6px #ffffff;
            text-transform: uppercase;
            white-space: nowrap;
        }

        .status-placed,
        .status-confirmed,
        .status-pending {
            color: #bb7613;
        }

        .status-preparing {
            color: #a15cbb;
        }

        .status-out-for-delivery,
        .status-shipped {
            color: #2674c9;
        }

        .status-delivered,
        .status-completed {
            color: #24834d;
        }

        .status-cancelled,
        .status-failed {
            color: #d83232;
        }

        .status-unknown {
            color: #81756e;
        }

        /* Restaurant image and information */
        .restaurant-section {
            display: flex;
            align-items: center;
            gap: 18px;
            padding: 22px 0;
        }

        .restaurant-image {
            width: 100px;
            height: 88px;
            flex-shrink: 0;
            display: block;
            object-fit: cover;
            border-radius: 16px;
            background: #eee5de;
            box-shadow: 4px 4px 10px var(--shadow),
                        -4px -4px 10px #ffffff;
        }

        .restaurant-info {
            min-width: 0;
        }

        .restaurant-info h3 {
            font-size: 19px;
            margin-bottom: 7px;
            overflow-wrap: anywhere;
        }

        .restaurant-info p {
            color: var(--text-muted);
            font-size: 13px;
            line-height: 1.7;
            overflow-wrap: anywhere;
        }

        /* Ordered items */
        .items-heading {
            font-size: 16px;
            font-weight: 800;
            margin-bottom: 15px;
            color: #443832;
        }

        .items-list {
            display: flex;
            flex-direction: column;
            gap: 12px;
        }

        .item-row {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 15px;
            padding: 13px 16px;
            border-radius: 15px;
            background: var(--page-bg);
            box-shadow: inset 3px 3px 6px #e5dcd5,
                        inset -3px -3px 6px #ffffff;
        }

        .item-main {
            display: flex;
            align-items: center;
            gap: 15px;
            min-width: 0;
        }

        .menu-image {
            width: 76px;
            height: 70px;
            flex-shrink: 0;
            object-fit: cover;
            display: block;
            border-radius: 12px;
            background: #eee5de;
            box-shadow: 3px 3px 7px rgba(180, 125, 95, 0.12);
        }

        .item-info {
            min-width: 0;
        }

        .item-name {
            font-size: 15px;
            font-weight: 700;
            color: #443832;
            margin-bottom: 7px;
            overflow-wrap: anywhere;
        }

        .item-quantity {
            font-size: 12px;
            color: var(--text-muted);
        }

        .item-price {
            color: #e94b2c;
            font-size: 15px;
            font-weight: 800;
            white-space: nowrap;
        }

        .empty-items {
            padding: 15px;
            color: var(--text-muted);
            font-size: 14px;
        }

        /* Delivery details */
        .details-toggle {
            display: inline-block;
            margin-top: 20px;
            padding: 12px 17px;
            border: none;
            border-radius: 12px;
            background: var(--page-bg);
            color: var(--primary);
            font-family: inherit;
            font-size: 13px;
            font-weight: 700;
            cursor: pointer;
            box-shadow: 4px 4px 9px var(--shadow),
                        -4px -4px 9px #ffffff;
            transition: 0.2s ease;
        }

        .details-toggle:hover {
            box-shadow: inset 3px 3px 6px var(--shadow),
                        inset -3px -3px 6px #ffffff;
        }

        .delivery-details {
            display: none;
            margin-top: 18px;
            padding: 20px;
            border-radius: 16px;
            background: var(--page-bg);
            box-shadow: inset 4px 4px 8px #e3dad3,
                        inset -4px -4px 8px #ffffff;
        }

        .delivery-details.open {
            display: block;
        }

        .details-grid {
            display: grid;
            grid-template-columns: repeat(2, minmax(0, 1fr));
            gap: 20px;
        }

        .detail-label {
            color: #8b7e76;
            font-size: 12px;
            margin-bottom: 6px;
        }

        .detail-value {
            color: #43372f;
            font-size: 14px;
            font-weight: 600;
            line-height: 1.6;
            overflow-wrap: anywhere;
        }

        /* Total */
        .order-total {
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 15px;
            margin-top: 24px;
            padding-top: 20px;
            border-top: 1px solid var(--border);
        }

        .total-label {
            color: #51443d;
            font-size: 15px;
            font-weight: 700;
        }

        .total-amount {
            color: var(--primary);
            font-size: 25px;
            font-weight: 900;
            white-space: nowrap;
        }

        /* Empty state */
        .empty-state {
            text-align: center;
            padding: 65px 25px;
            border-radius: 24px;
            background: var(--page-bg);
            box-shadow: 8px 8px 18px var(--shadow),
                        -8px -8px 18px #ffffff;
        }

        .empty-icon {
            width: 95px;
            height: 95px;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 25px;
            font-size: 42px;
            border-radius: 50%;
            box-shadow: 7px 7px 15px var(--shadow),
                        -7px -7px 15px #ffffff;
        }

        .empty-state h2 {
            font-size: 25px;
            margin-bottom: 12px;
        }

        .empty-state p {
            max-width: 430px;
            margin: 0 auto 26px;
            color: var(--text-muted);
            font-size: 14px;
            line-height: 1.8;
        }

        .browse-button {
            display: inline-block;
            padding: 14px 25px;
            border-radius: 13px;
            background: var(--primary);
            color: #ffffff;
            font-size: 14px;
            font-weight: 800;
            box-shadow: 5px 5px 11px #d9c7be,
                        -4px -4px 10px #ffffff;
            transition: 0.2s ease;
        }

        .browse-button:hover {
            background: var(--primary-dark);
            transform: translateY(-2px);
        }

        /* Footer */
        .footer {
            margin-top: auto;
            padding: 25px 5%;
            background: var(--page-bg);
            color: #81756e;
            text-align: center;
            font-size: 13px;
            border-top: 1px solid var(--border);
            box-shadow: 0 -5px 18px rgba(100, 70, 50, 0.04);
        }

        @media (max-width: 850px) {
            .navbar {
                width: 96%;
                padding: 12px 18px;
                flex-wrap: wrap;
            }

            .nav-actions {
                gap: 8px;
            }

            .nav-button {
                padding: 10px 13px;
                font-size: 13px;
            }

            .page-container {
                width: 92%;
            }
        }

        @media (max-width: 650px) {
            .navbar {
                width: 100%;
                border-radius: 0 0 20px 20px;
                flex-direction: column;
                gap: 12px;
            }

            .nav-actions {
                width: 100%;
                justify-content: center;
            }

            .nav-button {
                min-height: 40px;
                padding: 10px 12px;
                font-size: 12px;
            }

            .page-container {
                margin-top: 30px;
            }

            .order-card {
                padding: 18px;
                border-radius: 18px;
            }

            .restaurant-image {
                width: 85px;
                height: 80px;
            }

            .menu-image {
                width: 65px;
                height: 65px;
            }

            .item-row {
                padding: 12px;
            }

            .item-main {
                gap: 11px;
            }

            .details-grid {
                grid-template-columns: 1fr;
            }

            .total-amount {
                font-size: 22px;
            }
        }

        @media (max-width: 380px) {
            .app-name {
                font-size: 23px;
            }

            .restaurant-section {
                align-items: flex-start;
                gap: 12px;
            }

            .restaurant-image {
                width: 72px;
                height: 72px;
            }

            .menu-image {
                width: 55px;
                height: 58px;
            }

            .item-main {
                gap: 9px;
            }

            .item-name {
                font-size: 13px;
            }

            .item-price {
                font-size: 13px;
            }

            .order-total {
                align-items: flex-start;
                flex-direction: column;
            }
        }
    </style>
</head>

<body>

    <!-- Navigation -->
    <header class="navbar">
        <a class="logo" href="<%= contextPath %>/restaurant">
            <img
                src="<%= contextPath %>/images/FoodWorld_logo.jpg"
                alt="FoodWorld Logo"
                class="logo-image"
                onerror="this.style.display='none';">

            <span class="app-name">Food<span>World</span></span>
        </a>

        <nav class="nav-actions">
            <a class="nav-button"
               href="<%= contextPath %>/restaurant">
                Restaurants
            </a>

            <a class="nav-button"
               href="<%= contextPath %>/cart">
                My Cart
            </a>

            <a class="nav-button active"
               href="<%= contextPath %>/orders">
                My Orders
            </a>

            <% if (session.getAttribute("user") == null) { %>
                <a class="nav-button"
                   href="<%= contextPath %>/login.jsp">
                    Login
                </a>
			<%
			} else {
			%>

			<a class="nav-button login-button"
				href="<%=contextPath%>/profile"> My Profile </a> <a
				class="nav-button" href="<%=contextPath%>/logout"> Logout </a>

			<%
			}
			%>
		</nav>
    </header>

    <!-- Main content -->
    <main class="page-container">

        <div class="page-heading">
            <div class="heading-text">
                <h1>My Orders</h1>
                <p>Track your orders and revisit your FoodWorld order history.</p>
            </div>

            <div class="order-count">
                <%= orderCount %>
                <%= orderCount == 1 ? "Order" : "Orders" %>
            </div>
        </div>

        <% if (orderDetailsList == null || orderDetailsList.isEmpty()) { %>

            <section class="empty-state">
                <div class="empty-icon">🛍️</div>

                <h2>No orders yet!</h2>

                <p>
                    You haven't placed any orders yet.
                    Explore our restaurants, choose your favourite food,
                    and your orders will appear here.
                </p>

                <a href="<%= contextPath %>/restaurant"
                   class="browse-button">
                    Explore Restaurants
                </a>
            </section>

        <% } else { %>

            <% for (OrderDetails orderDetails : orderDetailsList) {

                if (orderDetails == null ||
                    orderDetails.getOrder() == null) {
                    continue;
                }

                Order order = orderDetails.getOrder();
                Restaurant restaurant = orderDetails.getRestaurant();

                List<MenuDetails> menuDetailsList =
                    orderDetails.getMenuDetailsList();

                String status = order.getStatus() == null
                    ? "UNKNOWN"
                    : order.getStatus().trim();

                String statusClass = status
                    .toLowerCase(Locale.ROOT)
                    .replaceAll("[^a-z0-9]+", "-");

                Timestamp orderDate = order.getOrderDate();

                String formattedDate = orderDate == null
                    ? "Date unavailable"
                    : dateFormat.format(orderDate);

                String restaurantName = restaurant == null
                    ? "Restaurant unavailable"
                    : String.valueOf(restaurant.getName());

                String cuisineType = restaurant == null ||
                    restaurant.getCuisineType() == null
                    ? ""
                    : restaurant.getCuisineType();

                String restaurantAddress = restaurant == null ||
                    restaurant.getAddress() == null
                    ? ""
                    : restaurant.getAddress();

                // Same fallback convention used in restaurant.jsp.
                String restaurantImagePath = restaurant == null
                    ? null
                    : restaurant.getImagePath();

                if (restaurantImagePath == null ||
                    restaurantImagePath.trim().isEmpty()) {
                    restaurantImagePath = "images/restaurant/default.jpg";
                }

                String restaurantImageUrl =
                    imageUrl.apply(restaurantImagePath);

                String paymentMode = order.getPaymentMode() == null
                    ? "Not available"
                    : order.getPaymentMode().replace("_", " ");

                String landmark = order.getLandmark();
                String detailsId = "details-" + order.getOrderId();
            %>

                <article class="order-card">

                    <!-- Order header -->
                    <div class="order-header">
                        <div>
                            <div class="order-number">
                                Order #<%= order.getOrderId() %>
                            </div>

                            <div class="order-date">
                                Placed on <%= escapeHtml.apply(formattedDate) %>
                            </div>
                        </div>

                        <span class="status-badge status-<%= statusClass %>">
                            <%= escapeHtml.apply(status.replace("_", " ")) %>
                        </span>
                    </div>

                    <!-- Restaurant image and details -->
                    <section class="restaurant-section">

                        <img
                            src="<%= restaurantImageUrl %>"
                            alt="<%= escapeHtml.apply(restaurantName) %>"
                            class="restaurant-image"
                            loading="lazy"
                            onerror="this.onerror=null;this.src='<%= contextPath %>/images/restaurant/default.jpg';">

                        <div class="restaurant-info">
                            <h3><%= escapeHtml.apply(restaurantName) %></h3>

                            <% if (!cuisineType.trim().isEmpty()) { %>
                                <p><%= escapeHtml.apply(cuisineType) %></p>
                            <% } %>

                            <% if (!restaurantAddress.trim().isEmpty()) { %>
                                <p><%= escapeHtml.apply(restaurantAddress) %></p>
                            <% } %>
                        </div>
                    </section>

                    <!-- Menu items and their stored images -->
                    <section class="items-section">
                        <h3 class="items-heading">Items Ordered</h3>

                        <div class="items-list">

                            <% if (menuDetailsList == null ||
                                   menuDetailsList.isEmpty()) { %>

                                <div class="empty-items">
                                    No item details are available for this order.
                                </div>

                            <% } else {
                                for (MenuDetails menuDetails : menuDetailsList) {

                                    if (menuDetails == null ||
                                        menuDetails.getOrderItem() == null) {
                                        continue;
                                    }

                                    OrderItem orderItem =
                                        menuDetails.getOrderItem();

                                    Menu menu = menuDetails.getMenu();

                                    String itemName = menu == null ||
                                        menu.getItem_name() == null
                                        ? "Menu item unavailable"
                                        : menu.getItem_name();

                                    // Same imagePath convention used in menu.jsp.
                                    String menuImagePath = menu == null
                                        ? null
                                        : menu.getImagePath();

                                    String menuImageUrl =
                                        imageUrl.apply(menuImagePath);
                            %>

                                <div class="item-row">

                                    <div class="item-main">

                                        <% if (menuImageUrl != null &&
                                               !menuImageUrl.isEmpty()) { %>

                                            <img
                                                src="<%= menuImageUrl %>"
                                                alt="<%= escapeHtml.apply(itemName) %>"
                                                class="menu-image"
                                                loading="lazy"
                                                onerror="this.onerror=null;this.style.visibility='hidden';">

                                        <% } else { %>

                                            <div
                                                class="menu-image"
                                                role="img"
                                                aria-label="Menu image unavailable">
                                            </div>

                                        <% } %>

                                        <div class="item-info">
                                            <div class="item-name">
                                                <%= escapeHtml.apply(itemName) %>
                                            </div>

                                            <div class="item-quantity">
                                                Quantity:
                                                <%= orderItem.getQuantity() %>
                                            </div>
                                        </div>

                                    </div>

                                    <div class="item-price">
                                        &#8377;<%= String.format(
                                            Locale.ROOT,
                                            "%.2f",
                                            orderItem.getItemTotal()) %>
                                    </div>

                                </div>

                            <%  }
                               }
                            %>

                        </div>
                    </section>

                    <!-- Delivery details toggle -->
                    <button
                        type="button"
                        class="details-toggle"
                        aria-expanded="false"
                        aria-controls="<%= detailsId %>"
                        onclick="toggleDetails(this, '<%= detailsId %>')">
                        View Delivery Details +
                    </button>

                    <section class="delivery-details" id="<%= detailsId %>">

                        <div class="details-grid">

                            <div>
                                <div class="detail-label">Delivery Name</div>
                                <div class="detail-value">
                                    <%= escapeHtml.apply(order.getDeliveryName()) %>
                                </div>
                            </div>

                            <div>
                                <div class="detail-label">Phone Number</div>
                                <div class="detail-value">
                                    <%= escapeHtml.apply(order.getDeliveryPhone()) %>
                                </div>
                            </div>

                            <div>
                                <div class="detail-label">Delivery Address</div>
                                <div class="detail-value">
                                    <%= escapeHtml.apply(order.getDeliveryAddress()) %>
                                </div>
                            </div>

                            <div>
                                <div class="detail-label">Landmark</div>
                                <div class="detail-value">
                                    <%= landmark == null || landmark.trim().isEmpty()
                                        ? "Not provided"
                                        : escapeHtml.apply(landmark) %>
                                </div>
                            </div>

                            <div>
                                <div class="detail-label">Payment Method</div>
                                <div class="detail-value">
                                    <%= escapeHtml.apply(paymentMode) %>
                                </div>
                            </div>

                            <div>
                                <div class="detail-label">Order ID</div>
                                <div class="detail-value">
                                    #<%= order.getOrderId() %>
                                </div>
                            </div>

                        </div>
                    </section>

                    <!-- Order total -->
                    <div class="order-total">
                        <div class="total-label">Total Amount</div>

                        <div class="total-amount">
                            &#8377;<%= String.format(
                                Locale.ROOT,
                                "%.2f",
                                order.getTotalAmount()) %>
                        </div>
                    </div>

                </article>

            <% } %>

        <% } %>

    </main>

    <footer class="footer">
        &copy; <%= java.time.Year.now() %> FoodWorld. All rights reserved.
    </footer>

    <script>
        function toggleDetails(button, detailsId) {
            const details = document.getElementById(detailsId);

            if (!details) {
                return;
            }

            const isOpen = details.classList.toggle("open");

            button.setAttribute("aria-expanded", String(isOpen));
            button.textContent = isOpen
                ? "Hide Delivery Details −"
                : "View Delivery Details +";
        }
    </script>

</body>
</html>