<%@ page import="java.sql.*" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.math.BigDecimal" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Liam's Grocery Order List</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 20px;
            background-color: #f0f0f0;
        }
        h1 {
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
    </style>
</head>
<body>
    <div class="header">
        <a href="listprod.jsp">Products</a>
        <a href="listorder.jsp">List Orders</a>
        <a href="showcart.jsp">Shopping Cart</a>
    </div>

    <h1>Order List</h1>

<%
try {
    Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
} catch (java.lang.ClassNotFoundException e) {
    out.println("<p style='color: red;'>ClassNotFoundException: " + e + "</p>");
}

Connection conn = null;
try {
    String url = "jdbc:sqlserver://cosc304_sqlserver:1433;DatabaseName=orders;TrustServerCertificate=True";
    String user = "sa";
    String password = "304#sa#pw";
    conn = DriverManager.getConnection(url, user, password);

    //currency formatter
    NumberFormat currency = NumberFormat.getCurrencyInstance();

    String queryOrders = "SELECT o.orderId, o.orderDate, o.totalAmount, o.customerId, " +
                         "c.firstName, c.lastName FROM ordersummary o " +
                         "JOIN customer c ON o.customerId = c.customerId";
    Statement stmt = conn.createStatement();
    ResultSet rs = stmt.executeQuery(queryOrders);

    //outer table for orders
    out.println("<table>");
    out.println("<tr>");
    out.println("<th>Order Id</th><th>Order Date</th><th>Customer Id</th><th>Customer Name</th><th>Total Amount</th>");
    out.println("</tr>");

    while (rs.next()) {
        int orderId = rs.getInt("orderId");
        Timestamp orderDate = rs.getTimestamp("orderDate");
        BigDecimal totalAmount = rs.getBigDecimal("totalAmount");
        String totalAmountFormatted = currency.format(totalAmount);
        int customerId = rs.getInt("customerId");
        String customerName = rs.getString("firstName") + " " + rs.getString("lastName");

        out.println("<tr>");
        out.println("<td>" + orderId + "</td>");
        out.println("<td>" + orderDate + "</td>");
        out.println("<td>" + customerId + "</td>");
        out.println("<td>" + customerName + "</td>");
        out.println("<td>" + totalAmountFormatted + "</td>");
        out.println("</tr>");

        String queryOrderProducts = "SELECT op.productId, op.quantity, op.price " +
                                    "FROM orderproduct op " +
                                    "WHERE op.orderId = ?";
        PreparedStatement psOrderProducts = conn.prepareStatement(queryOrderProducts);
        psOrderProducts.setInt(1, orderId);
        ResultSet rsProducts = psOrderProducts.executeQuery();

        //inner table for products
        out.println("<tr><td colspan='5'>");
        out.println("<table>");
        out.println("<tr><th>Product Id</th><th>Quantity</th><th>Price</th></tr>");

        while (rsProducts.next()) {
            int productId = rsProducts.getInt("productId");
            int quantity = rsProducts.getInt("quantity");
            BigDecimal price = rsProducts.getBigDecimal("price");
            String priceFormatted = currency.format(price);

            out.println("<tr>");
            out.println("<td>" + productId + "</td>");
            out.println("<td>" + quantity + "</td>");
            out.println("<td>" + priceFormatted + "</td>");
            out.println("</tr>");
        }

        out.println("</table>");
        out.println("</td></tr>");

        rsProducts.close();
        psOrderProducts.close();
    }

    out.println("</table>");

    rs.close();
    stmt.close();

} catch (SQLException e) {
    out.println("<p style='color: red;'>SQLException: " + e.getMessage() + "</p>");
} finally {
    if (conn != null) {
        try {
            conn.close();
        } catch (SQLException e) {
            out.println("<p style='color: red;'>Error closing connection: " + e.getMessage() + "</p>");
        }
    }
}
%>

<div style='text-align: center;'>
    <a href="listprod.jsp" class="action-button">Continue Shopping</a>
    <a href="showcart.jsp" class="action-button">View Cart</a>
</div>

</body>
</html>
