
<%@ page import="java.util.List" %>
<%@ page import="com.tap.model.Menu" %>
<%@ page import="com.tap.model.Cart" %>
<%@ page import="com.tap.model.CartItem" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);

    String contextPath = request.getContextPath();
    List<Menu> allMenu = (List<Menu>) request.getAttribute("allMenu");
    String cartError = request.getParameter("cartError");
    Cart cart = (Cart) session.getAttribute("cart");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>FoodWorld | Menu</title>

    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: Arial, Helvetica, sans-serif;
            background: #f8f3ef;
            color: #262626;
            min-height: 100vh;
            display: flex;
            flex-direction: column;
        }

        /* Navigation bar */
        .navbar {
            min-height: 82px;
            padding: 10px 5%;
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: 20px;
            background: #f8f3ef;
            box-shadow: 0 4px 15px rgba(180, 125, 95, 0.12);
            position: sticky;
            top: 0;
            z-index: 100;
        }

        .logo {
            display: flex;
            align-items: center;
            gap: 10px;
            color: #e94b2c;
            font-size: 27px;
            font-weight: bold;
            text-decoration: none;
            flex-shrink: 0;
        }

        .logo-img {
            width: 55px;
            height: 55px;
            object-fit: contain;
            display: block;
        }

        .nav-links {
            display: flex;
            align-items: center;
            justify-content: flex-end;
            gap: 12px;
            flex-wrap: wrap;
        }

        .nav-links a {
            display: inline-block;
            text-decoration: none;
            padding: 11px 17px;
            border-radius: 10px;
            background: #f8f3ef;
            color: #38302c;
            font-size: 14px;
            font-weight: 600;
            box-shadow:
                5px 5px 10px rgba(180, 125, 95, 0.15),
                -5px -5px 10px rgba(255, 255, 255, 0.9);
            transition: all 0.25s ease;
        }

        .nav-links a:hover {
            background: #f4512a;
            color: #ffffff;
            box-shadow:
                3px 3px 8px rgba(180, 80, 45, 0.2),
                -3px -3px 8px rgba(255, 255, 255, 0.65);
            transform: translateY(-1px);
        }

        .nav-links a:active {
            transform: translateY(1px);
        }

        /* Hero section */
        .hero {
            text-align: center;
            padding: 48px 20px 35px;
        }

        .hero h1 {
            font-size: 35px;
            margin-bottom: 12px;
        }

        .hero h1 span {
            color: #f4512a;
        }

        .hero p {
            color: #746b66;
            font-size: 16px;
            line-height: 1.6;
        }

        /* Menu section */
        .menu-container {
            width: 86%;
            max-width: 1200px;
            margin: 0 auto 55px;
            min-height: 300px;
            flex: 1;
        }

        .menu-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(240px, 1fr));
            gap: 25px;
        }

        .menu-card {
            background: #f8f3ef;
            border-radius: 16px;
            overflow: hidden;
            box-shadow:
                7px 7px 16px rgba(180, 125, 95, 0.15),
                -7px -7px 16px rgba(255, 255, 255, 0.85);
            transition: transform 0.25s ease, box-shadow 0.25s ease;
        }

        .menu-card:hover {
            transform: translateY(-4px);
            box-shadow:
                10px 10px 22px rgba(180, 125, 95, 0.18),
                -7px -7px 18px rgba(255, 255, 255, 0.9);
        }

        .menu-image {
            width: 100%;
            height: 190px;
            display: block;
            object-fit: cover;
            background: #eee5de;
        }

        .menu-details {
            padding: 18px;
        }

        .menu-details h3 {
            font-size: 19px;
            margin-bottom: 10px;
            line-height: 1.4;
        }

        .description {
            font-size: 14px;
            color: #746b66;
            line-height: 1.5;
            min-height: 42px;
            margin-bottom: 12px;
        }

        .price {
            color: #e94b2c;
            font-size: 21px;
            font-weight: bold;
            margin-bottom: 14px;
        }

        .availability {
            font-size: 13px;
            margin-bottom: 15px;
        }

        .available {
            color: #16803c;
        }

        .unavailable {
            color: #d92d20;
        }

        /* Add to cart */
        .cart-form {
            width: 100%;
        }

        .add-cart-btn {
            width: 100%;
            padding: 12px;
            border: none;
            border-radius: 10px;
            background: #f4512a;
            color: #ffffff;
            font-size: 15px;
            font-weight: bold;
            cursor: pointer;
            box-shadow: 3px 3px 8px rgba(180, 80, 45, 0.15);
            transition: all 0.2s ease;
        }

        .add-cart-btn:hover:not(:disabled) {
            background: #d9401d;
            transform: translateY(-1px);
        }

        .add-cart-btn:disabled {
            background: #98a2b3;
            cursor: not-allowed;
            box-shadow: none;
        }

        /* Quantity controls */
        .quantity-control {
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 15px;
            width: 100%;
        }

        .quantity-control form {
            margin: 0;
        }

        .quantity-btn {
            width: 36px;
            height: 36px;
            border: none;
            border-radius: 10px;
            background: #f8f3ef;
            color: #e94b2c;
            font-size: 22px;
            font-weight: bold;
            cursor: pointer;
            box-shadow:
                4px 4px 8px rgba(180, 125, 95, 0.15),
                -4px -4px 8px rgba(255, 255, 255, 0.9);
            transition: all 0.2s ease;
        }

        .quantity-btn:hover {
            background: #f4512a;
            color: #ffffff;
        }

        .quantity-value {
            min-width: 20px;
            text-align: center;
            font-size: 16px;
            font-weight: bold;
        }

        /* Cart error message */
        .message {
            margin-bottom: 24px;
            padding: 14px 18px;
            border-radius: 10px;
            background: #fff1f0;
            color: #b42318;
            border: 1px solid #ffd5d2;
            text-align: center;
            line-height: 1.6;
        }

        /* Empty menu message */
        .empty-message {
            background: #f8f3ef;
            padding: 40px 20px;
            border-radius: 16px;
            text-align: center;
            color: #746b66;
            box-shadow:
                7px 7px 16px rgba(180, 125, 95, 0.12),
                -7px -7px 16px rgba(255, 255, 255, 0.85);
        }

        .empty-message h3 {
            color: #262626;
            margin-bottom: 10px;
            font-size: 21px;
        }

        .empty-message p {
            line-height: 1.6;
        }

        .back-link {
            display: inline-block;
            margin-top: 20px;
            color: #e94b2c;
            text-decoration: none;
            font-weight: bold;
        }

        .back-link:hover {
            text-decoration: underline;
        }

        /* Footer */
        footer {
            margin-top: auto;
            padding: 26px 5%;
            background: #f8f3ef;
            color: #746b66;
            border-top: 1px solid #eee5de;
            border-radius: 16px 16px 0 0;
            text-align: center;
            font-size: 13px;
            box-shadow:
                5px 5px 12px rgba(180, 125, 95, 0.08),
                -5px -5px 12px rgba(255, 255, 255, 0.9);
        }

        /* Responsive layout */
        @media (max-width: 700px) {
            .navbar {
                justify-content: center;
                padding: 14px 5%;
            }

            .nav-links {
                justify-content: center;
                gap: 10px;
            }

            .nav-links a {
                padding: 10px 13px;
            }

            .hero {
                padding: 35px 15px 25px;
            }

            .hero h1 {
                font-size: 28px;
            }

            .menu-container {
                width: 90%;
            }

            .menu-grid {
                grid-template-columns: 1fr;
            }
        }

        @media (max-width: 380px) {
            .logo {
                font-size: 23px;
            }

            .logo-img {
                width: 45px;
                height: 45px;
            }

            .nav-links a {
                padding: 9px 11px;
                font-size: 13px;
            }
        }
    </style>
</head>

<body>

    <!-- Navigation -->
    <nav class="navbar">
        <a class="logo" href="<%= contextPath %>/restaurant">
            <img
                src="<%= contextPath %>/images/FoodWorld_logo.jpg"
                alt="FoodWorld Logo"
                class="logo-img">
            <span>FoodWorld</span>
        </a>

        <div class="nav-links">
            <a href="<%= contextPath %>/restaurant">Restaurants</a>
            <a href="<%= contextPath %>/cart">My Cart</a>
            <a href="<%= contextPath %>/orders">My Orders</a>

            <% if (session.getAttribute("user") == null) { %>
                <a href="<%= contextPath %>/login.jsp">Login</a>
			<%
			} else {
			%>

			<a class="nav-button login-button"
				href="<%=contextPath%>/profile"> My Profile </a> <a
				class="nav-button" href="<%=contextPath%>/logout"> Logout </a>

			<%
			}
			%>
		</div>
    </nav>

    <!-- Hero section -->
    <section class="hero">
        <h1>Explore Our <span>Menu</span></h1>
        <p>Discover delicious dishes and add your favourites to your cart.</p>
    </section>

    <!-- Menu items -->
    <main class="menu-container">

        <% if ("differentRestaurant".equals(cartError)) { %>
            <div class="message">
                Your cart already contains items from another restaurant.
                Please continue with that restaurant or clear your cart
                before choosing items from this restaurant.
            </div>
        <% } %>

        <% if (allMenu != null && !allMenu.isEmpty()) { %>

            <div class="menu-grid">

                <% for (Menu menu : allMenu) {
                    boolean available = menu.isIs_available();
                    String imagePath = menu.getImagePath();
                    int quantity = 0;

                    if (cart != null && cart.getItems() != null) {
                        for (CartItem cartItem : cart.getItems()) {
                            if (cartItem.getMenu().getMenuId() == menu.getMenuId()) {
                                quantity = cartItem.getQuantity();
                                break;
                            }
                        }
                    }
                %>

                    <article class="menu-card">

                        <% if (imagePath != null && !imagePath.trim().isEmpty()) { %>
                            <img
                                class="menu-image"
                                src="<%= contextPath %>/<%= imagePath.replaceFirst("^/+", "") %>"
                                alt="<%= menu.getItem_name() %>"
                                onerror="this.onerror=null;this.style.display='none';">
                        <% } else { %>
                            <div class="menu-image"></div>
                        <% } %>

                        <div class="menu-details">

                            <h3><%= menu.getItem_name() %></h3>

                            <p class="description">
                                <%= menu.getDescription() != null
                                    ? menu.getDescription()
                                    : "Enjoy this delicious dish." %>
                            </p>

                            <p class="price">
                                ₹<%= String.format("%.2f", menu.getPrice()) %>
                            </p>

                            <p class="availability <%= available ? "available" : "unavailable" %>">
                                <%= available ? "Available" : "Currently unavailable" %>
                            </p>

                            <!-- Add to cart or quantity controls -->
                            <% if (!available) { %>

                                <button
                                    type="button"
                                    class="add-cart-btn"
                                    disabled>
                                    Unavailable
                                </button>

                            <% } else if (quantity == 0) { %>

                                <form
                                    class="cart-form"
                                    action="<%= contextPath %>/cart"
                                    method="post">

                                    <input type="hidden" name="action" value="add">
                                    <input
                                        type="hidden"
                                        name="menuId"
                                        value="<%= menu.getMenuId() %>">

                                    <button type="submit" class="add-cart-btn">
                                        + Add to Cart
                                    </button>
                                </form>

                            <% } else { %>

                                <div class="quantity-control">

                                    <!-- Decrease quantity -->
                                    <form
                                        action="<%= contextPath %>/cart"
                                        method="post">

                                        <input type="hidden" name="action" value="update">
                                        <input
                                            type="hidden"
                                            name="menuId"
                                            value="<%= menu.getMenuId() %>">
                                        <input type="hidden" name="source" value="menu">
                                        <input
                                            type="hidden"
                                            name="restaurantId"
                                            value="<%= menu.getRestaurantId() %>">
                                        <input
                                            type="hidden"
                                            name="quantity"
                                            value="<%= quantity - 1 %>">

                                        <button
                                            type="submit"
                                            class="quantity-btn"
                                            aria-label="Decrease quantity">
                                            −
                                        </button>
                                    </form>

                                    <span class="quantity-value">
                                        <%= quantity %>
                                    </span>

                                    <!-- Increase quantity -->
                                    <form
                                        action="<%= contextPath %>/cart"
                                        method="post">

                                        <input type="hidden" name="action" value="update">
                                        <input
                                            type="hidden"
                                            name="menuId"
                                            value="<%= menu.getMenuId() %>">
                                        <input type="hidden" name="source" value="menu">
                                        <input
                                            type="hidden"
                                            name="restaurantId"
                                            value="<%= menu.getRestaurantId() %>">
                                        <input
                                            type="hidden"
                                            name="quantity"
                                            value="<%= quantity + 1 %>">

                                        <button
                                            type="submit"
                                            class="quantity-btn"
                                            aria-label="Increase quantity">
                                            +
                                        </button>
                                    </form>

                                </div>

                            <% } %>

                        </div>
                    </article>

                <% } %>

            </div>

        <% } else { %>

            <div class="empty-message">
                <h3>No menu items found</h3>
                <p>There are no menu items to display for this restaurant.</p>

                <a
                    class="back-link"
                    href="<%= contextPath %>/restaurant">
                    &larr; Back to Restaurants
                </a>
            </div>

        <% } %>

    </main>

    <!-- Footer -->
    <footer>
        &copy; 2026 FoodWorld. All rights reserved.
    </footer>

</body>
</html>
