
<%@ page import="com.tap.model.Cart" %>
<%@ page import="com.tap.model.CartItem" %>
<%@ page import="com.tap.model.Menu" %>
<%@ page import="java.util.Collection" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);

    String contextPath = request.getContextPath();

    Cart cart = (Cart) session.getAttribute("cart");
    Collection<CartItem> cartItems =
        (cart != null) ? cart.getItems() : null;

    boolean emptyCart = (cartItems == null || cartItems.isEmpty());

    double totalAmount = (cart != null) ? cart.getTotalAmount() : 0.0;
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>FoodWorld | My Cart</title>

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
            transform: translateY(-1px);
        }

        .nav-links a:active {
            transform: translateY(1px);
        }

        /* Page heading */
        .page-heading {
            text-align: center;
            padding: 42px 20px 30px;
        }

        .page-heading h1 {
            font-size: 34px;
            margin-bottom: 12px;
        }

        .page-heading h1 span {
            color: #f4512a;
        }

        .page-heading p {
            color: #746b66;
            font-size: 15px;
            line-height: 1.6;
        }

        /* Main cart layout */
        .cart-container {
            width: 90%;
            max-width: 1200px;
            margin: 0 auto 55px;
            flex: 1;
        }

        .cart-layout {
            display: grid;
            grid-template-columns: minmax(0, 1.8fr) minmax(280px, 1fr);
            align-items: start;
            gap: 28px;
        }

        .cart-items {
            display: flex;
            flex-direction: column;
            gap: 20px;
            min-width: 0;
        }

        .cart-item {
            display: flex;
            align-items: center;
            gap: 20px;
            padding: 20px;
            border-radius: 16px;
            background: #f8f3ef;
            box-shadow:
                7px 7px 16px rgba(180, 125, 95, 0.14),
                -7px -7px 16px rgba(255, 255, 255, 0.85);
        }

        .item-image {
            width: 125px;
            height: 125px;
            flex-shrink: 0;
            object-fit: cover;
            border-radius: 12px;
            background: #eee5de;
        }

        .item-details {
            flex: 1;
            min-width: 0;
        }

        .item-details h3 {
            font-size: 19px;
            line-height: 1.4;
            margin-bottom: 10px;
            overflow-wrap: anywhere;
        }

        .item-price {
            color: #746b66;
            font-size: 14px;
            margin-bottom: 15px;
        }

        .item-subtotal {
            color: #e94b2c;
            font-size: 17px;
            font-weight: bold;
            margin-top: 14px;
        }

        /* Quantity controls */
        .quantity-control {
            display: flex;
            align-items: center;
            gap: 14px;
        }

        .quantity-control form {
            margin: 0;
        }

        .quantity-btn {
            width: 35px;
            height: 35px;
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

        /* Order summary */
        .cart-summary {
            padding: 26px;
            border-radius: 16px;
            background: #f8f3ef;
            box-shadow:
                7px 7px 16px rgba(180, 125, 95, 0.14),
                -7px -7px 16px rgba(255, 255, 255, 0.85);
        }

        .cart-summary h2 {
            font-size: 23px;
            margin-bottom: 24px;
        }

        .summary-row {
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 12px;
            margin-bottom: 18px;
            color: #746b66;
            font-size: 14px;
        }

        .summary-row span:last-child {
            color: #38302c;
            font-weight: 600;
            text-align: right;
        }

        .summary-divider {
            border: none;
            border-top: 1px solid #e7d9ce;
            margin: 20px 0;
        }

        .summary-total {
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 12px;
            font-size: 17px;
            font-weight: bold;
            margin-bottom: 24px;
        }

        .summary-total span:last-child {
            color: #e94b2c;
            font-size: 22px;
            white-space: nowrap;
        }

        /* Checkout and shopping links */
        .checkout-btn {
            display: flex;
            width: 100%;
            min-height: 48px;
            align-items: center;
            justify-content: center;
            padding: 13px 16px;
            border: none;
            border-radius: 10px;
            background: #f4512a;
            color: #ffffff;
            text-decoration: none;
            text-align: center;
            font-size: 15px;
            font-weight: bold;
            cursor: pointer;
            box-shadow: 4px 4px 10px rgba(180, 80, 45, 0.18);
            transition: all 0.25s ease;
        }

        .checkout-btn:hover {
            background: #d9401d;
            transform: translateY(-2px);
        }

        .continue-shopping {
            display: block;
            text-align: center;
            margin-top: 20px;
            color: #e94b2c;
            font-size: 14px;
            font-weight: bold;
            text-decoration: none;
        }

        .continue-shopping:hover {
            text-decoration: underline;
        }

        /* Empty cart */
        .empty-cart {
            max-width: 650px;
            margin: 0 auto;
            padding: 50px 25px;
            text-align: center;
            border-radius: 18px;
            background: #f8f3ef;
            box-shadow:
                8px 8px 18px rgba(180, 125, 95, 0.14),
                -8px -8px 18px rgba(255, 255, 255, 0.9);
        }

        .empty-cart h2 {
            font-size: 25px;
            margin-bottom: 14px;
        }

        .empty-cart p {
            color: #746b66;
            font-size: 15px;
            line-height: 1.7;
            margin-bottom: 24px;
        }

        .empty-cart .checkout-btn {
            max-width: 240px;
            margin: 0 auto;
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

        /* Responsive design */
        @media (max-width: 850px) {
            .cart-layout {
                grid-template-columns: 1fr;
            }

            .cart-summary {
                width: 100%;
            }
        }

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

            .page-heading {
                padding: 35px 15px 25px;
            }

            .page-heading h1 {
                font-size: 28px;
            }

            .cart-container {
                width: 92%;
            }
        }

        @media (max-width: 480px) {
            .cart-item {
                align-items: flex-start;
                gap: 14px;
                padding: 14px;
            }

            .item-image {
                width: 90px;
                height: 90px;
            }

            .item-details h3 {
                font-size: 16px;
            }

            .item-price {
                font-size: 13px;
            }

            .quantity-control {
                gap: 10px;
            }

            .quantity-btn {
                width: 32px;
                height: 32px;
            }

            .cart-summary {
                padding: 21px;
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
				href="<%=contextPath%>/profile.jsp"> My Profile </a> <a
				class="nav-button" href="<%=contextPath%>/logout"> Logout </a>

			<%
			}
			%>
		</div>
    </nav>

    <!-- Page heading -->
    <section class="page-heading">
        <h1>My <span>Cart</span></h1>
        <p>Review your favourite dishes before checking out.</p>
    </section>

    <!-- Cart content -->
    <main class="cart-container">

        <% if (emptyCart) { %>

            <section class="empty-cart">
                <h2>Your cart is empty</h2>
                <p>
                    You haven't added any delicious dishes yet.
                    Explore our restaurants and find something you love.
                </p>

                <a
                    class="checkout-btn"
                    href="<%= contextPath %>/restaurant">
                    Explore Restaurants
                </a>
            </section>

        <% } else { %>

            <div class="cart-layout">

                <!-- Cart items -->
                <section class="cart-items">

                    <% for (CartItem cartItem : cartItems) {
                        Menu menu = cartItem.getMenu();
                        String imagePath = menu.getImagePath();
                    %>

                        <article class="cart-item">

                            <% if (imagePath != null && !imagePath.trim().isEmpty()) { %>
                                <img
                                    class="item-image"
                                    src="<%= contextPath %>/<%= imagePath.replaceFirst("^/+", "") %>"
                                    alt="<%= menu.getItem_name() %>"
                                    onerror="this.onerror=null;this.style.display='none';">
                            <% } else { %>
                                <div class="item-image"></div>
                            <% } %>

                            <div class="item-details">

                                <h3><%= menu.getItem_name() %></h3>

                                <p class="item-price">
                                    Price: ₹<%= String.format("%.2f", menu.getPrice()) %>
                                </p>

                                <!-- Quantity controls -->
                                <div class="quantity-control">

                                    <!-- Decrease quantity -->
                                    <form
                                        action="<%= contextPath %>/cart"
                                        method="post">

                                        <input
                                            type="hidden"
                                            name="action"
                                            value="update">

                                        <input
                                            type="hidden"
                                            name="menuId"
                                            value="<%= menu.getMenuId() %>">

                                        <input
                                            type="hidden"
                                            name="quantity"
                                            value="<%= cartItem.getQuantity() - 1 %>">

                                        <input
                                            type="hidden"
                                            name="source"
                                            value="cart">

                                        <button
                                            type="submit"
                                            class="quantity-btn"
                                            aria-label="Decrease quantity">
                                            −
                                        </button>
                                    </form>

                                    <span class="quantity-value">
                                        <%= cartItem.getQuantity() %>
                                    </span>

                                    <!-- Increase quantity -->
                                    <form
                                        action="<%= contextPath %>/cart"
                                        method="post">

                                        <input
                                            type="hidden"
                                            name="action"
                                            value="update">

                                        <input
                                            type="hidden"
                                            name="menuId"
                                            value="<%= menu.getMenuId() %>">

                                        <input
                                            type="hidden"
                                            name="quantity"
                                            value="<%= cartItem.getQuantity() + 1 %>">

                                        <input
                                            type="hidden"
                                            name="source"
                                            value="cart">

                                        <button
                                            type="submit"
                                            class="quantity-btn"
                                            aria-label="Increase quantity">
                                            +
                                        </button>
                                    </form>

                                </div>

                                <p class="item-subtotal">
                                    Subtotal: ₹<%= String.format("%.2f", cartItem.getSubtotal()) %>
                                </p>

                            </div>
                        </article>

                    <% } %>

                </section>

                <!-- Order summary -->
                <aside class="cart-summary">

                    <h2>Order Summary</h2>

                    <div class="summary-row">
                        <span>Total Items</span>
                        <span><%= cartItems.size() %></span>
                    </div>

                    <div class="summary-row">
                        <span>Delivery</span>
                        <span>Calculated at checkout</span>
                    </div>

                    <hr class="summary-divider">

                    <div class="summary-total">
                        <span>Total Amount</span>
                        <span>₹<%= String.format("%.2f", totalAmount) %></span>
                    </div>

                    <a
                        class="checkout-btn"
                        href="<%= contextPath %>/checkout">
                        Proceed to Checkout
                    </a>

                    <a
                        class="continue-shopping"
                        href="<%= contextPath %>/restaurant">
                        &larr; Continue Shopping
                    </a>

                </aside>

            </div>

        <% } %>

    </main>

    <!-- Footer -->
    <footer>
        &copy; 2026 FoodWorld. All rights reserved.
    </footer>

</body>
</html>
