
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="com.tap.model.Cart" %>
<%@ page import="com.tap.model.CartItem" %>
<%@ page import="com.tap.model.Menu" %>
<%@ page import="java.text.DecimalFormat" %>

<%
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);

    String contextPath = request.getContextPath();

    Cart cart = (Cart) request.getAttribute("cart");
    if (cart == null) {
        cart = (Cart) session.getAttribute("cart");
    }

    if (cart == null || cart.isEmpty()) {
        response.sendRedirect(contextPath + "/cart");
        return;
    }

    double itemTotal = cart.getTotalAmount();
    double deliveryFee = itemTotal >= 499 ? 0 : 30;
    double totalAmount = itemTotal + deliveryFee;

    DecimalFormat money = new DecimalFormat("#,##0.00");

    String errorMessage = (String) request.getAttribute("errorMessage");

    String fullName = request.getParameter("fullName");
    String phone = request.getParameter("phone");
    String address = request.getParameter("address");
    String landmark = request.getParameter("landmark");

    if (fullName == null) fullName = "";
    if (phone == null) phone = "";
    if (address == null) address = "";
    if (landmark == null) landmark = "";
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">

<title>FoodWorld | Checkout</title>

<style>
* {
    margin: 0;
    padding: 0;
    box-sizing: border-box;
}

body {
    font-family: Arial, Helvetica, sans-serif;
    background: #f8f3ef;
    color: #292522;
    min-height: 100vh;
    display: flex;
    flex-direction: column;
}

/* Navigation */

.navbar {
    min-height: 78px;
    padding: 12px 5%;
    display: flex;
    justify-content: space-between;
    align-items: center;
    flex-wrap: wrap;
    gap: 18px;
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
    font-size: 26px;
    font-weight: bold;
    text-decoration: none;
}

.logo-img {
    width: 50px;
    height: 50px;
    object-fit: contain;
}

.nav-links {
    display: flex;
    align-items: center;
    justify-content: flex-end;
    gap: 12px;
    flex-wrap: wrap;
}

.nav-links a {
    text-decoration: none;
    padding: 11px 15px;
    border-radius: 10px;
    background: #f8f3ef;
    color: #38302c;
    font-size: 14px;
    font-weight: 600;
    box-shadow: 4px 4px 9px rgba(180, 125, 95, .12),
                -4px -4px 9px rgba(255, 255, 255, .9);
}

.nav-links a:hover {
    background: #f4512a;
    color: white;
}

/* Page heading */

.page-heading {
    text-align: center;
    padding: 36px 20px 28px;
}

.page-heading h1 {
    font-size: 32px;
    margin-bottom: 10px;
}

.page-heading h1 span {
    color: #f4512a;
}

.page-heading p {
    color: #746b66;
    font-size: 14px;
    line-height: 1.6;
}

/* Layout */

.checkout-container {
    width: 90%;
    max-width: 1200px;
    margin: 0 auto 45px;
    flex: 1;
}

.checkout-layout {
    display: grid;
    grid-template-columns: minmax(0, 1.45fr) minmax(300px, 1fr);
    align-items: start;
    gap: 25px;
}

.checkout-card,
.order-summary {
    min-width: 0;
    padding: 26px;
    border-radius: 17px;
    background: #f8f3ef;
    box-shadow: 7px 7px 17px rgba(180, 125, 95, .13),
                -7px -7px 17px rgba(255, 255, 255, .9);
    margin-bottom: 24px;
}

.checkout-card h2,
.order-summary h2 {
    font-size: 21px;
    margin-bottom: 22px;
}

.section-heading {
    display: flex;
    align-items: center;
    gap: 10px;
}

.section-icon {
    color: #f4512a;
    font-size: 23px;
}

/* Error */

.error-message {
    margin-bottom: 20px;
    padding: 13px 15px;
    color: #a32620;
    background: #fff0ee;
    border: 1px solid #f2c3be;
    border-radius: 9px;
    font-size: 13px;
    line-height: 1.5;
}

/* Form */

.form-group {
    margin-bottom: 18px;
}

.form-group > label {
    display: block;
    margin-bottom: 8px;
    font-size: 14px;
    font-weight: bold;
}

.form-group input,
.form-group textarea {
    display: block;
    width: 100%;
    padding: 13px;
    border: 1px solid #e7d9cf;
    border-radius: 9px;
    background: #fffaf6;
    color: #292522;
    font-family: inherit;
    font-size: 14px;
    outline: none;
}

.form-group input:focus,
.form-group textarea:focus {
    border-color: #f4512a;
    box-shadow: 0 0 0 3px rgba(244, 81, 42, .10);
}

.form-group textarea {
    min-height: 95px;
    resize: vertical;
    line-height: 1.5;
}

/* Payment options */

.payment-option {
    display: flex;
    align-items: center;
    gap: 13px;
    padding: 15px;
    margin-bottom: 12px;
    border: 1px solid #e7d9cf;
    border-radius: 12px;
    background: #fffaf6;
    cursor: pointer;
    transition: .2s;
}

.payment-option:hover {
    border-color: #f4512a;
}

.payment-option:has(input:checked) {
    border: 1.5px solid #f4512a;
    background: #fff1e9;
    box-shadow: 0 0 0 2px rgba(244, 81, 42, .06);
}

.payment-option input[type="radio"] {
    width: 17px;
    height: 17px;
    flex-shrink: 0;
    accent-color: #f4512a;
}

.payment-icon {
    width: 43px;
    height: 43px;
    flex-shrink: 0;
    display: flex;
    align-items: center;
    justify-content: center;
    border-radius: 11px;
    background: #fff0e7;
    color: #e94b2c;
    font-size: 23px;
    font-weight: bold;
}

.payment-details {
    flex: 1;
    min-width: 0;
}

.payment-title {
    display: block;
    color: #38302c;
    font-size: 14px;
    font-weight: bold;
    margin-bottom: 5px;
}

.payment-description {
    display: block;
    color: #746b66;
    font-size: 12px;
    line-height: 1.5;
}

.payment-note {
    margin-top: 12px;
    padding: 12px;
    color: #746b66;
    background: #fffaf6;
    border-radius: 9px;
    font-size: 12px;
    line-height: 1.6;
}

/* Ordered items */

.cart-item {
    display: flex;
    align-items: center;
    gap: 12px;
    padding: 15px 0;
    border-bottom: 1px solid #e7d9ce;
}

.cart-item:last-child {
    border-bottom: none;
}

.food-icon {
    width: 43px;
    height: 43px;
    flex-shrink: 0;
    display: flex;
    align-items: center;
    justify-content: center;
    background: #fff0e7;
    border-radius: 10px;
    font-size: 22px;
}

.cart-item-info {
    flex: 1;
    min-width: 0;
}

.food-name {
    font-size: 14px;
    font-weight: bold;
    overflow-wrap: anywhere;
    margin-bottom: 5px;
}

.food-quantity {
    font-size: 12px;
    color: #746b66;
}

.food-price {
    font-size: 13px;
    font-weight: bold;
    white-space: nowrap;
}

/* Order summary */

.summary-row {
    display: flex;
    justify-content: space-between;
    align-items: flex-start;
    gap: 12px;
    margin: 16px 0;
    font-size: 14px;
}

.summary-row span:first-child {
    color: #746b66;
}

.summary-row span:last-child {
    font-weight: 600;
    white-space: nowrap;
}

.summary-divider {
    border: none;
    border-top: 1px solid #e7d9ce;
    margin: 20px 0;
}

.total-row {
    font-size: 17px;
    font-weight: bold;
}

.total-row span:last-child {
    color: #e94b2c;
    font-size: 23px;
}

.delivery-note {
    margin-top: 8px;
    font-size: 12px;
    color: #746b66;
    line-height: 1.5;
}

.place-order-btn {
    width: 100%;
    min-height: 49px;
    padding: 14px;
    border: none;
    border-radius: 10px;
    background: #f4512a;
    color: white;
    font-size: 15px;
    font-weight: bold;
    cursor: pointer;
    margin-top: 10px;
    transition: .2s;
}

.place-order-btn:hover {
    background: #d9401d;
    transform: translateY(-1px);
}

.back-link {
    display: block;
    margin-top: 20px;
    text-align: center;
    color: #e94b2c;
    font-size: 14px;
    font-weight: bold;
    text-decoration: none;
}

.back-link:hover {
    text-decoration: underline;
}

.secure-note {
    margin-top: 13px;
    text-align: center;
    color: #746b66;
    font-size: 11px;
    line-height: 1.6;
}

/* Footer */

footer {
    margin-top: auto;
    padding: 24px 5%;
    background: #f8f3ef;
    color: #746b66;
    border-top: 1px solid #eee5de;
    text-align: center;
    font-size: 13px;
}

/* Responsive */

@media (max-width: 850px) {
    .checkout-layout {
        grid-template-columns: 1fr;
    }
}

@media (max-width: 600px) {
    .navbar {
        justify-content: center;
    }

    .nav-links {
        justify-content: center;
        gap: 9px;
    }

    .nav-links a {
        padding: 9px 11px;
        font-size: 12px;
    }

    .checkout-container {
        width: 94%;
    }

    .checkout-card,
    .order-summary {
        padding: 20px;
    }

    .page-heading h1 {
        font-size: 27px;
    }
}
</style>
</head>

<body>

<nav class="navbar">
    <a class="logo" href="<%= contextPath %>/restaurant">
        <img src="<%= contextPath %>/images/FoodWorld_logo.jpg"
             alt="FoodWorld Logo" class="logo-img">
        <span>FoodWorld</span>
    </a>

    <div class="nav-links">
        <a href="<%= contextPath %>/restaurant">Restaurants</a>
        <a href="<%= contextPath %>/cart">My Cart</a>
        <a href="<%= contextPath %>/orders">My Orders</a>

        <% if (session.getAttribute("user") == null) { %>
            <a href="<%= contextPath %>/login">Login</a>
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

<section class="page-heading">
    <h1>Secure <span>Checkout</span></h1>
    <p>Confirm your delivery details, review your items, and choose how to pay.</p>
</section>

<main class="checkout-container">

    <div class="checkout-layout">

        <!-- DELIVERY AND PAYMENT -->

        <section class="checkout-card">

            <h2 class="section-heading">
                <span class="section-icon">📍</span>
                Delivery Details
            </h2>

            <% if (errorMessage != null) { %>
                <div class="error-message" role="alert">
                    <%= errorMessage %>
                </div>
            <% } %>

            <form action="<%= contextPath %>/checkout"
                  method="post"
                  accept-charset="UTF-8"
                  onsubmit="return validateCheckout();">

                <div class="form-group">
                    <label for="fullName">Full Name *</label>
                    <input type="text"
                           id="fullName"
                           name="fullName"
                           value="<%= fullName %>"
                           placeholder="Enter your full name"
                           maxlength="100"
                           autocomplete="name"
                           required>
                </div>

                <div class="form-group">
                    <label for="phone">Phone Number *</label>
                    <input type="tel"
                           id="phone"
                           name="phone"
                           value="<%= phone %>"
                           placeholder="10-digit mobile number"
                           pattern="[0-9]{10}"
                           minlength="10"
                           maxlength="10"
                           inputmode="numeric"
                           autocomplete="tel"
                           required>
                </div>

                <div class="form-group">
                    <label for="address">Complete Delivery Address *</label>
                    <textarea id="address"
                              name="address"
                              placeholder="House number, street, area, city and PIN code"
                              maxlength="500"
                              autocomplete="street-address"
                              required><%= address %></textarea>
                </div>

                <div class="form-group">
                    <label for="landmark">Landmark (Optional)</label>
                    <input type="text"
                           id="landmark"
                           name="landmark"
                           value="<%= landmark %>"
                           placeholder="Nearby landmark"
                           maxlength="150">
                </div>

                <hr class="summary-divider">

                <h2 class="section-heading">
                    <span class="section-icon">💳</span>
                    Payment Method
                </h2>

                <label class="payment-option" for="paymentCOD">
                    <input type="radio"
                           id="paymentCOD"
                           name="paymentMethod"
                           value="COD"
                           required>

                    <span class="payment-icon">💵</span>

                    <span class="payment-details">
                        <span class="payment-title">Cash on Delivery</span>
                        <span class="payment-description">
                            Pay cash when your order arrives.
                        </span>
                    </span>
                </label>

                <label class="payment-option" for="paymentUPI">
                    <input type="radio"
                           id="paymentUPI"
                           name="paymentMethod"
                           value="UPI"
                           required>

                    <span class="payment-icon">📱</span>

                    <span class="payment-details">
                        <span class="payment-title">UPI Payment</span>
                        <span class="payment-description">
                            Google Pay, PhonePe, Paytm, or another supported UPI app.
                        </span>
                    </span>
                </label>

                <label class="payment-option" for="paymentCredit">
                    <input type="radio"
                           id="paymentCredit"
                           name="paymentMethod"
                           value="CREDIT_CARD"
                           required>

                    <span class="payment-icon">💳</span>

                    <span class="payment-details">
                        <span class="payment-title">Credit Card</span>
                        <span class="payment-description">
                            Credit card payment through a secure payment gateway.
                        </span>
                    </span>
                </label>

                <label class="payment-option" for="paymentDebit">
                    <input type="radio"
                           id="paymentDebit"
                           name="paymentMethod"
                           value="DEBIT_CARD"
                           required>

                    <span class="payment-icon">🏦</span>

                    <span class="payment-details">
                        <span class="payment-title">Debit Card</span>
                        <span class="payment-description">
                            Debit card payment through a secure payment gateway.
                        </span>
                    </span>
                </label>

                <p class="payment-note" id="paymentNote">
                    Select a payment method. Online payments require a payment
                    gateway and will not be processed by this form alone.
                </p>

                <button type="submit" class="place-order-btn">
                    Place Order · ₹<%= money.format(totalAmount) %>
                </button>

            </form>

            <a class="back-link" href="<%= contextPath %>/cart">
                &#8592; Back to Cart
            </a>

        </section>

        <!-- CART ITEMS AND ORDER SUMMARY -->

        <aside>

            <section class="order-summary">

                <h2 class="section-heading">
                    <span class="section-icon">🛒</span>
                    Your Ordered Items
                </h2>

                <% for (CartItem cartItem : cart.getItems()) {
                       Menu menu = cartItem.getMenu();
                %>

                    <div class="cart-item">

                        <div class="food-icon">🍽️</div>

                        <div class="cart-item-info">
                            <div class="food-name">
                                <%= menu.getItem_name() %>
                            </div>

                            <div class="food-quantity">
                                Quantity: <%= cartItem.getQuantity() %>
                            </div>

                            <div class="food-quantity">
                                ₹<%= money.format(menu.getPrice()) %> each
                            </div>
                        </div>

                        <div class="food-price">
                            ₹<%= money.format(cartItem.getSubtotal()) %>
                        </div>

                    </div>

                <% } %>

                <a class="back-link" href="<%= contextPath %>/cart">
                    Edit Cart
                </a>

            </section>

            <section class="order-summary">

                <h2 class="section-heading">
                    <span class="section-icon">🧾</span>
                    Order Summary
                </h2>

                <div class="summary-row">
                    <span>Item Total</span>
                    <span>₹<%= money.format(itemTotal) %></span>
                </div>

                <div class="summary-row">
                    <span>Delivery Fee</span>
                    <span>
                        <% if (deliveryFee == 0) { %>
                            FREE
                        <% } else { %>
                            ₹<%= money.format(deliveryFee) %>
                        <% } %>
                    </span>
                </div>

                <p class="delivery-note">
                    <% if (deliveryFee == 0) { %>
                        You qualify for free delivery!
                    <% } else { %>
                        Free delivery on orders of ₹499 or more.
                    <% } %>
                </p>

                <hr class="summary-divider">

                <div class="summary-row total-row">
                    <span>Total Amount</span>
                    <span>₹<%= money.format(totalAmount) %></span>
                </div>

                <p class="secure-note">
                    Please verify your delivery details before placing your order.
                    Online payments require payment gateway integration.
                </p>

            </section>

        </aside>

    </div>

</main>

<footer>
    &copy; 2026 FoodWorld. All rights reserved.
</footer>

<script>
function validateCheckout() {
    const fullName = document.getElementById("fullName").value.trim();
    const phone = document.getElementById("phone").value.trim();
    const address = document.getElementById("address").value.trim();

    const paymentSelected = document.querySelector(
        'input[name="paymentMethod"]:checked'
    );

    if (!fullName) {
        alert("Please enter your full name.");
        return false;
    }

    if (!/^[0-9]{10}$/.test(phone)) {
        alert("Please enter a valid 10-digit phone number.");
        return false;
    }

    if (!address) {
        alert("Please enter your delivery address.");
        return false;
    }

    if (!paymentSelected) {
        alert("Please select a payment method.");
        return false;
    }

    return true;
}

const paymentNote = document.getElementById("paymentNote");

document.querySelectorAll('input[name="paymentMethod"]')
    .forEach(function(option) {
        option.addEventListener("change", function() {
            if (this.value === "COD") {
                paymentNote.textContent =
                    "You can pay cash when your order arrives.";
            } else if (this.value === "UPI") {
                paymentNote.textContent =
                    "UPI payment requires a supported payment gateway. Selecting this option does not initiate payment.";
            } else {
                paymentNote.textContent =
                    "Card payment requires a secure payment gateway. Do not enter card numbers, CVVs, or PINs on this page.";
            }
        });
    });
</script>

</body>
</html>
