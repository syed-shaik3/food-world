
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" import="com.tap.model.User" %>

<%!
    // Safely display user-provided text in HTML.
    private String escapeHtml(String value) {
        if (value == null) {
            return "";
        }

        return value.replace("&", "&amp;")
                    .replace("<", "&lt;")
                    .replace(">", "&gt;")
                    .replace("\"", "&quot;")
                    .replace("'", "&#39;");
    }
%>

<%
    String contextPath = request.getContextPath();

    User profileUser = (User) request.getAttribute("profileUser");

    if (profileUser == null) {
        response.sendRedirect(contextPath + "/profile");
        return;
    }

    String errorMessage = (String) request.getAttribute("errorMessage");

    boolean updated = "true".equals(request.getParameter("updated"));

    String username = profileUser.getUsername() == null
            ? "" : profileUser.getUsername();

    String email = profileUser.getEmail() == null
            ? "" : profileUser.getEmail();

    String phone = profileUser.getPhone() == null
            ? "" : profileUser.getPhone();

    String address = profileUser.getAddress() == null
            ? "" : profileUser.getAddress();

    String firstLetter = username.trim().isEmpty()
            ? "U" : username.trim().substring(0, 1).toUpperCase();
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">

<title>My Profile | FoodWorld</title>

<style>
    * {
        margin: 0;
        padding: 0;
        box-sizing: border-box;
    }

    :root {
        --primary: #f4512a;
        --primary-dark: #d93d1b;
        --background: #fffaf6;
        --white: #ffffff;
        --text: #252525;
        --muted: #777777;
        --border: #eee3dc;
        --success: #18794e;
        --success-bg: #eaf8ef;
        --error: #b42318;
        --error-bg: #fff0ee;
        --shadow: 0 8px 28px rgba(70, 43, 25, 0.08);
    }

    body {
        font-family: Arial, Helvetica, sans-serif;
        background: var(--background);
        color: var(--text);
        min-height: 100vh;
    }

    a {
        text-decoration: none;
        color: inherit;
    }

    /* Navigation bar */

    .navbar {
        width: 100%;
        min-height: 82px;
        background: var(--white);
        display: flex;
        align-items: center;
        justify-content: space-between;
        padding: 14px 6%;
        gap: 22px;
        box-shadow: 0 3px 14px rgba(0, 0, 0, 0.045);
        position: relative;
        z-index: 2;
    }

    .brand {
        display: flex;
        align-items: center;
        gap: 11px;
        flex-shrink: 0;
    }

    .brand img {
        width: 53px;
        height: 53px;
        object-fit: contain;
        border-radius: 12px;
    }

    .brand-name {
        font-size: 25px;
        font-weight: 800;
        letter-spacing: -0.7px;
        color: var(--primary);
    }

    .nav-links {
        display: flex;
        align-items: center;
        justify-content: flex-end;
        flex-wrap: wrap;
        gap: 12px;
    }

    .nav-button {
        display: inline-flex;
        align-items: center;
        justify-content: center;
        min-height: 41px;
        padding: 10px 17px;
        border-radius: 24px;
        font-size: 14px;
        font-weight: 600;
        color: #383838;
        background: #fff;
        border: 1px solid var(--border);
        transition: 0.2s ease;
    }

    .nav-button:hover {
        color: var(--primary);
        border-color: var(--primary);
        transform: translateY(-1px);
    }

    .nav-button.active,
    .nav-button.primary {
        background: var(--primary);
        color: #fff;
        border-color: var(--primary);
    }

    .nav-button.active:hover,
    .nav-button.primary:hover {
        background: var(--primary-dark);
        color: #fff;
    }

    /* Main layout */

    .page-container {
        width: min(1100px, 92%);
        margin: 38px auto 55px;
    }

    .page-heading {
        margin-bottom: 25px;
    }

    .page-heading h1 {
        font-size: 30px;
        font-weight: 800;
        margin-bottom: 9px;
    }

    .page-heading p {
        color: var(--muted);
        font-size: 15px;
        line-height: 1.6;
    }

    .profile-layout {
        display: grid;
        grid-template-columns: 300px minmax(0, 1fr);
        gap: 25px;
        align-items: start;
    }

    .card {
        background: var(--white);
        border: 1px solid #f0e7e1;
        border-radius: 18px;
        box-shadow: var(--shadow);
        overflow: hidden;
    }

    /* Profile summary */

    .profile-summary {
        padding: 30px 24px;
        text-align: center;
    }

    .avatar {
        width: 100px;
        height: 100px;
        border-radius: 50%;
        margin: 0 auto 17px;
        display: flex;
        align-items: center;
        justify-content: center;
        background: linear-gradient(135deg, #ff794d, #ed421f);
        color: white;
        font-size: 39px;
        font-weight: 800;
        box-shadow: 0 7px 20px rgba(244, 81, 42, 0.22);
    }

    .profile-summary h2 {
        font-size: 22px;
        margin-bottom: 8px;
        overflow-wrap: anywhere;
    }

    .profile-summary .email {
        color: var(--muted);
        font-size: 14px;
        line-height: 1.6;
        overflow-wrap: anywhere;
    }

    .profile-badge {
        display: inline-block;
        margin-top: 17px;
        padding: 8px 15px;
        border-radius: 20px;
        background: #fff0e9;
        color: var(--primary-dark);
        font-size: 12px;
        font-weight: 700;
    }

    .summary-divider {
        height: 1px;
        background: var(--border);
        margin: 25px 0 20px;
    }

    .summary-note {
        color: var(--muted);
        font-size: 13px;
        line-height: 1.8;
        text-align: left;
    }

    /* Profile form */

    .form-card {
        padding: 30px;
    }

    .form-heading {
        padding-bottom: 20px;
        margin-bottom: 24px;
        border-bottom: 1px solid var(--border);
    }

    .form-heading h2 {
        font-size: 22px;
        margin-bottom: 8px;
    }

    .form-heading p {
        color: var(--muted);
        font-size: 14px;
        line-height: 1.6;
    }

    .message {
        padding: 13px 15px;
        border-radius: 9px;
        font-size: 14px;
        line-height: 1.5;
        margin-bottom: 22px;
    }

    .success-message {
        color: var(--success);
        background: var(--success-bg);
        border: 1px solid #c9eed7;
    }

    .error-message {
        color: var(--error);
        background: var(--error-bg);
        border: 1px solid #ffd4ce;
    }

    .form-grid {
        display: grid;
        grid-template-columns: repeat(2, minmax(0, 1fr));
        gap: 22px 20px;
    }

    .form-group {
        display: flex;
        flex-direction: column;
        gap: 9px;
        min-width: 0;
    }

    .form-group.full-width {
        grid-column: 1 / -1;
    }

    .form-group label {
        font-size: 14px;
        font-weight: 700;
        color: #353535;
    }

    .form-group input,
    .form-group textarea {
        width: 100%;
        padding: 13px 14px;
        border: 1px solid #e4dcd6;
        border-radius: 9px;
        outline: none;
        background: #fff;
        color: var(--text);
        font-family: inherit;
        font-size: 14px;
        transition: border-color 0.2s, box-shadow 0.2s;
    }

    .form-group input {
        min-height: 46px;
    }

    .form-group textarea {
        min-height: 105px;
        resize: vertical;
        line-height: 1.6;
    }

    .form-group input:focus,
    .form-group textarea:focus {
        border-color: var(--primary);
        box-shadow: 0 0 0 3px rgba(244, 81, 42, 0.10);
    }

    .form-group input[readonly] {
        background: #f7f5f3;
        color: #737373;
        cursor: not-allowed;
    }

    .field-help {
        color: var(--muted);
        font-size: 12px;
        line-height: 1.5;
    }

    .form-actions {
        display: flex;
        align-items: center;
        justify-content: flex-end;
        flex-wrap: wrap;
        gap: 12px;
        margin-top: 28px;
        padding-top: 23px;
        border-top: 1px solid var(--border);
    }

    .button {
        display: inline-flex;
        align-items: center;
        justify-content: center;
        min-height: 45px;
        padding: 12px 22px;
        border-radius: 9px;
        border: 1px solid transparent;
        cursor: pointer;
        font-size: 14px;
        font-weight: 700;
        font-family: inherit;
        transition: 0.2s ease;
    }

    .button-secondary {
        color: #454545;
        background: #fff;
        border-color: #e4dcd6;
    }

    .button-secondary:hover {
        background: #f7f3ef;
    }

    .button-primary {
        background: var(--primary);
        color: #fff;
    }

    .button-primary:hover {
        background: var(--primary-dark);
        transform: translateY(-1px);
    }

    /* Footer */

    .footer {
        text-align: center;
        padding: 25px 15px;
        color: var(--muted);
        font-size: 13px;
        border-top: 1px solid #f0e7e1;
        background: #fff;
    }

    .footer strong {
        color: var(--primary);
    }

    /* Responsive layout */

    @media (max-width: 850px) {
        .navbar {
            padding: 14px 4%;
            flex-wrap: wrap;
        }

        .nav-links {
            width: 100%;
            justify-content: flex-start;
        }

        .profile-layout {
            grid-template-columns: 1fr;
        }

        .profile-summary {
            padding: 25px;
        }

        .summary-note {
            text-align: center;
        }
    }

    @media (max-width: 560px) {
        .page-container {
            margin-top: 25px;
        }

        .page-heading h1 {
            font-size: 26px;
        }

        .brand-name {
            font-size: 22px;
        }

        .brand img {
            width: 45px;
            height: 45px;
        }

        .nav-links {
            gap: 8px;
        }

        .nav-button {
            padding: 9px 12px;
            font-size: 12px;
        }

        .form-card {
            padding: 21px 17px;
        }

        .form-grid {
            grid-template-columns: 1fr;
            gap: 19px;
        }

        .form-group.full-width {
            grid-column: auto;
        }

        .form-actions {
            flex-direction: column-reverse;
            align-items: stretch;
        }

        .button {
            width: 100%;
        }
    }
</style>
</head>

<body>

<!-- Navigation -->
<nav class="navbar">

    <a class="brand" href="<%= contextPath %>/restaurant">
        <img src="<%= contextPath %>/images/FoodWorld_logo.jpg"
             alt="FoodWorld Logo">
        <span class="brand-name">FoodWorld</span>
    </a>

    <div class="nav-links">
        <a class="nav-button"
           href="<%= contextPath %>/restaurant">Restaurants</a>

        <a class="nav-button"
           href="<%= contextPath %>/cart">My Cart</a>

        <a class="nav-button"
           href="<%= contextPath %>/orders">My Orders</a>

        <a class="nav-button active"
           href="<%= contextPath %>/profile">My Profile</a>

        <a class="nav-button"
           href="<%= contextPath %>/logout">Logout</a>
    </div>

</nav>

<!-- Main content -->
<main class="page-container">

    <div class="page-heading">
        <h1>My Profile</h1>
        <p>Manage your personal information and keep your account details up to date.</p>
    </div>

    <div class="profile-layout">

        <!-- Left profile summary -->
        <aside class="card profile-summary">

            <div class="avatar">
                <%= escapeHtml(firstLetter) %>
            </div>

            <h2><%= escapeHtml(username) %></h2>

            <p class="email">
                <%= escapeHtml(email) %>
            </p>

            <span class="profile-badge">FoodWorld Member</span>

            <div class="summary-divider"></div>

            <p class="summary-note">
                Keep your contact details updated so your food ordering
                experience remains smooth and convenient.
            </p>

        </aside>

        <!-- Right profile form -->
        <section class="card form-card">

            <div class="form-heading">
                <h2>Personal Information</h2>
                <p>Update the information below and save your changes.</p>
            </div>

            <% if (updated) { %>
                <div class="message success-message" role="status">
                    Your profile has been updated successfully.
                </div>
            <% } %>

            <% if (errorMessage != null && !errorMessage.isEmpty()) { %>
                <div class="message error-message" role="alert">
                    <%= escapeHtml(errorMessage) %>
                </div>
            <% } %>

            <form action="<%= contextPath %>/profile"
                  method="post">

                <div class="form-grid">

                    <div class="form-group">
                        <label for="username">Full Name</label>
                        <input
                            type="text"
                            id="username"
                            name="username"
                            value="<%= escapeHtml(username) %>"
                            placeholder="Enter your full name"
                            maxlength="100"
                            autocomplete="name"
                            required>
                    </div>

                    <div class="form-group">
                        <label for="email">Email Address</label>
                        <input
                            type="email"
                            id="email"
                            name="email"
                            value="<%= escapeHtml(email) %>"
                            readonly
                            aria-describedby="email-help">

                        <span class="field-help" id="email-help">
                            Email cannot be changed here.
                        </span>
                    </div>

                    <div class="form-group full-width">
                        <label for="phone">Phone Number</label>
                        <input
                            type="tel"
                            id="phone"
                            name="phone"
                            value="<%= escapeHtml(phone) %>"
                            placeholder="Enter your 10-digit phone number"
                            pattern="[0-9]{10}"
                            inputmode="numeric"
                            maxlength="10"
                            autocomplete="tel"
                            title="Enter a 10-digit phone number"
                            required>

                        <span class="field-help">
                            Enter a valid 10-digit phone number.
                        </span>
                    </div>

                    <div class="form-group full-width">
                        <label for="address">Delivery Address</label>
                        <textarea
                            id="address"
                            name="address"
                            placeholder="Enter your complete delivery address"
                            maxlength="500"
                            autocomplete="street-address"
                            required><%= escapeHtml(address) %></textarea>
                    </div>

                </div>

                <div class="form-actions">

                    <a class="button button-secondary"
                       href="<%= contextPath %>/restaurant">
                        Cancel
                    </a>

                    <button type="submit"
                            class="button button-primary">
                        Save Changes
                    </button>

                </div>

            </form>

        </section>

    </div>

</main>

<!-- Footer -->
<footer class="footer">
    Made with care by <strong>FoodWorld</strong> · Your food, your way.
</footer>

</body>
</html>
