<%@ page import="java.sql.*" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Iterator" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.math.BigDecimal" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Liam's Grocery Order Processing</title>
    <style>
        body {
            font-family: Arial, sans-serif;
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
        .error {
            color: red;
            text-align: center;
        }
    </style>
</head>
<body>

<h1>Order Processing</h1>

<% 
//kept the same css from the previous pages
String custId = request.getParameter("customerId");
@SuppressWarnings({"unchecked"})
HashMap<String, ArrayList<Object>> productList = (HashMap<String, ArrayList<Object>>) session.getAttribute("productList");

// add error checking for customer ID
if (custId == null || !custId.matches("\\d+")) {
    out.println("<p class='error'>Invalid customer ID. Enter a valid number.</p>");
    return;
}

String customerPassword = request.getParameter("password");
if (customerPassword == null || customerPassword.isEmpty()) {
    out.println("<p class='error'>Password is required. Please enter a password.</p>");
    return;
}

Connection conn = null;
PreparedStatement pstmt = null;
ResultSet rs = null;

try {

    Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
    String url = "jdbc:sqlserver://cosc304_sqlserver:1433;DatabaseName=orders;TrustServerCertificate=True";
    String user = "sa";
    String password = "304#sa#pw";
    conn = DriverManager.getConnection(url, user, password);

    // checking if the customer exists and password is correct
    //this is kind of dumb because it passes the password in plain text, in the url but it works
    String queryCustomer = "SELECT * FROM customer WHERE customerId = ? AND password = ?";
    pstmt = conn.prepareStatement(queryCustomer);
    pstmt.setInt(1, Integer.parseInt(custId));
    pstmt.setString(2, customerPassword);
    rs = pstmt.executeQuery();
    if (!rs.next()) {
        out.println("<p class='error'>Invalid customer ID or incorrect password.</p>");
        return;
    }

    // add error checking for product list
    if (productList == null || productList.isEmpty()) {
        out.println("<p class='error'>Your shopping cart is empty. Please add items to the cart before placing an order.</p>");
        return;
    }

	//summary of the order
    String insertOrderSummary = "INSERT INTO ordersummary (orderDate, totalAmount, customerId) VALUES (GETDATE(), ?, ?)";
    pstmt = conn.prepareStatement(insertOrderSummary, Statement.RETURN_GENERATED_KEYS);
    pstmt.setBigDecimal(1, BigDecimal.ZERO); 
    pstmt.setInt(2, Integer.parseInt(custId));
    pstmt.executeUpdate();
    rs = pstmt.getGeneratedKeys();
    rs.next();
    int orderId = rs.getInt(1);
    String insertOrderProduct = "INSERT INTO orderproduct (orderId, productId, quantity, price) VALUES (?, ?, ?, ?)";
    pstmt = conn.prepareStatement(insertOrderProduct);

    BigDecimal totalAmount = BigDecimal.ZERO;
    for (Map.Entry<String, ArrayList<Object>> entry : productList.entrySet()) {
        ArrayList<Object> product = entry.getValue();

        int productId = Integer.parseInt((String) product.get(0));
        int quantity = (Integer) product.get(3);
        BigDecimal price = new BigDecimal((String) product.get(2));

        pstmt.setInt(1, orderId);
        pstmt.setInt(2, productId);
        pstmt.setInt(3, quantity);
        pstmt.setBigDecimal(4, price);
        pstmt.executeUpdate();
        totalAmount = totalAmount.add(price.multiply(BigDecimal.valueOf(quantity)));
    }
	//update the total amount in the order summary table
    String updateTotalAmount = "UPDATE ordersummary SET totalAmount = ? WHERE orderId = ?";
    pstmt = conn.prepareStatement(updateTotalAmount);
    pstmt.setBigDecimal(1, totalAmount);
    pstmt.setInt(2, orderId);
    pstmt.executeUpdate();
    out.println("<h2>Order Confirmation</h2>");
    out.println("<p>Order ID: " + orderId + "</p>");
    out.println("<p>Customer ID: " + custId + "</p>");
    out.println("<p>Total Amount: " + NumberFormat.getCurrencyInstance().format(totalAmount) + "</p>");
    out.println("<h3>Ordered Items:</h3>");
    out.println("<table>");
    out.println("<tr><th>Product ID</th><th>Quantity</th><th>Price</th></tr>");

    for (Map.Entry<String, ArrayList<Object>> entry : productList.entrySet()) {
        ArrayList<Object> product = entry.getValue();
        int productId = Integer.parseInt((String) product.get(0));
        int quantity = (Integer) product.get(3);
        BigDecimal price = new BigDecimal((String) product.get(2));

        out.println("<tr>");
        out.println("<td>" + productId + "</td>");
        out.println("<td>" + quantity + "</td>");
        out.println("<td>" + NumberFormat.getCurrencyInstance().format(price) + "</td>");
        out.println("</tr>");
    }
    out.println("</table>");
    session.removeAttribute("productList");

} catch (ClassNotFoundException e) {
    out.println("<p class='error'>Error loading database driver: " + e.getMessage() + "</p>");
} catch (SQLException e) {
    out.println("<p class='error'>SQL Error: " + e.getMessage() + "</p>");
} finally {
    //close nicely
    if (rs != null) try { rs.close(); } catch (SQLException ignored) {}
    if (pstmt != null) try { pstmt.close(); } catch (SQLException ignored) {}
    if (conn != null) try { conn.close(); } catch (SQLException ignored) {}
}
%>

</body>
</html>
