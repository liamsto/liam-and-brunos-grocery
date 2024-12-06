<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Iterator" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.sql.*" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Your Shopping Cart</title>
    <style>
        /* Cool fancy CSS for bonus marks */
        body {
            font-family: Arial, sans-serif;
            background-color: #f0f0f0;
            margin: 20px;
        }
        h1, h2 {
            text-align: center;
        }
        table {
            width: 80%;
            margin: 20px auto;
            border-collapse: collapse;
            text-align: left;
        }
        table, th, td {
            border: 1px solid #ddd;
        }
        th, td {
            padding: 8px;
        }
        th {
            background-color: #f4f4f4;
        }
        tr:nth-child(even) {
            background-color: #f9f9f9;
        }
        tr:hover {
            background-color: #f1f1f1;
        }
        .remove-button {
            background-color: #ff4d4d;
            color: white;
            border: none;
            padding: 5px 10px;
            cursor: pointer;
            transition: background-color 0.3s;
            font-size: 0.9em;
        }
        .remove-button:hover {
            background-color: #cc0000;
        }
        .header {
            background-color: #007bff;
            padding: 10px;
            text-align: center;
        }
        .header a {
            color: #fff;
            margin: 0 15px;
            font-weight: bold;
            text-decoration: none;
            transition: color 0.3s;
        }
        .header a:hover {
            color: #cce0ff;
        }
        .action-button {
            background-color: #007bff;
            color: #fff;
            border: none;
            padding: 10px 20px;
            margin: 10px;
            border-radius: 5px;
            text-align: center;
            text-decoration: none;
            font-size: 1em;
            cursor: pointer;
            transition: background-color 0.3s;
        }
        .action-button:hover {
            background-color: #0056b3;
        }
        .quantity-input {
            width: 50px;
            text-align: center;
        }
    </style>
    <script>
        // Remove item from cart and update quantity
        function removeItem(productId) {
            window.location.href = 'removeitem.jsp?productId=' + productId;
        }
        function updateQuantity(productId) {
            const quantity = document.getElementById('quantity-' + productId).value;
            window.location.href = 'updatecart.jsp?productId=' + productId + '&quantity=' + quantity;
        }
    </script>
</head>
<body>
    <div class="header">
        <a href="listprod.jsp">Products</a>
        <a href="listorder.jsp">List Orders</a>
        <a href="showcart.jsp">Shopping Cart</a>
    </div>

<%
    String userId = (String) session.getAttribute("authenticatedUser");

    if (userId == null) {
        out.println("<h1>You must be logged in to view your cart!</h1>");
    } else {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
            String url = "jdbc:sqlserver://cosc304_sqlserver:1433;DatabaseName=orders;TrustServerCertificate=True";
            String dbUser = "sa";
            String dbPassword = "304#sa#pw";
            conn = DriverManager.getConnection(url, dbUser, dbPassword);

            // Query to fetch cart items for the user
            String query = "SELECT c.productId, p.productName, c.quantity, c.price, (c.quantity * c.price) AS subtotal " +
                           "FROM cart c " +
                           "JOIN product p ON c.productId = p.productId " +
                           "WHERE c.userId = ?";
            pstmt = conn.prepareStatement(query);
            pstmt.setString(1, userId);
            rs = pstmt.executeQuery();

            // If cart is empty
            if (!rs.isBeforeFirst()) {
                out.println("<h1>Your shopping cart is empty!</h1>");
            } else {
                NumberFormat currFormat = NumberFormat.getCurrencyInstance();
                double total = 0;

                out.println("<h1>Your Shopping Cart</h1>");
                out.print("<table><tr><th>Product Id</th><th>Product Name</th><th>Quantity</th>");
                out.println("<th>Price</th><th>Subtotal</th><th>Action</th></tr>");

                while (rs.next()) {
                    String productId = rs.getString("productId");
                    String productName = rs.getString("productName");
                    int quantity = rs.getInt("quantity");
                    double price = rs.getDouble("price");
                    double subtotal = rs.getDouble("subtotal");

                    out.print("<tr>");
                    out.print("<td>" + productId + "</td>");
                    out.print("<td>" + productName + "</td>");
                    out.print("<td align=\"center\">");
                    out.print("<input type='number' id='quantity-" + productId + "' class='quantity-input' value='" + quantity + "' min='1'>");
                    out.print("<button onclick=\"updateQuantity('" + productId + "')\">Update</button>");
                    out.print("</td>");
                    out.print("<td align=\"right\">" + currFormat.format(price) + "</td>");
                    out.print("<td align=\"right\">" + currFormat.format(subtotal) + "</td>");
                    out.print("<td><button class=\"remove-button\" onclick=\"removeItem('" + productId + "')\">Remove</button></td>");
                    out.print("</tr>");

                    total += subtotal;
                }

                out.println("<tr><td colspan=\"5\" align=\"right\"><b>Order Total</b></td>"
                        + "<td align=\"right\">" + currFormat.format(total) + "</td></tr>");
                out.println("</table>");

                out.println("<div style='text-align: center;'>");
                out.println("<a href=\"checkout.jsp\" class=\"action-button\">Check Out</a>");
                out.println("<a href=\"listprod.jsp\" class=\"action-button\">Continue Shopping</a>");
                out.println("</div>");
            }
        } catch (Exception e) {
            out.println("<p style='color: red;'>Error loading cart: " + e.getMessage() + "</p>");
        } finally {
            if (rs != null) try { rs.close(); } catch (SQLException ignored) {}
            if (pstmt != null) try { pstmt.close(); } catch (SQLException ignored) {}
            if (conn != null) try { conn.close(); } catch (SQLException ignored) {}
        }
    }
%>
</body>
</html>
