<%@ page import="java.sql.*" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.ArrayList" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Update Cart</title>
</head>
<body>
<%
    // Retrieve parameters
    String productId = request.getParameter("productId");
    String quantityStr = request.getParameter("quantity");
    String userId = (String) session.getAttribute("authenticatedUser"); // Logged-in user ID

    if (userId == null) {
        out.println("<p style='color: red;'>You must be logged in to update your cart.</p>");
        return;
    }

    if (productId == null || quantityStr == null) {
        out.println("<p style='color: red;'>Invalid product or quantity.</p>");
        return;
    }

    int quantity = 0;
    try {
        quantity = Integer.parseInt(quantityStr);
        if (quantity < 1) {
            out.println("<p style='color: red;'>Quantity must be at least 1.</p>");
            return;
        }
    } catch (NumberFormatException e) {
        out.println("<p style='color: red;'>Invalid format.</p>");
        return;
    }

    // Update session-based cart
    @SuppressWarnings({"unchecked"})
    HashMap<String, ArrayList<Object>> productList = (HashMap<String, ArrayList<Object>>) session.getAttribute("productList");

    if (productList != null) {
        ArrayList<Object> product = productList.get(productId);
        if (product != null) {
            product.set(3, quantity); // Update the quantity in session
            session.setAttribute("productList", productList);
        }
    }

    // Update the database cart
    Connection conn = null;
    PreparedStatement pstmt = null;

    try {
        Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
        String url = "jdbc:sqlserver://cosc304_sqlserver:1433;DatabaseName=orders;TrustServerCertificate=True";
        String dbUser = "sa";
        String dbPassword = "304#sa#pw";
        conn = DriverManager.getConnection(url, dbUser, dbPassword);

        // Update the quantity in the cart table
        String updateQuery = "UPDATE cart SET quantity = ? WHERE userId = ? AND productId = ?";
        pstmt = conn.prepareStatement(updateQuery);
        pstmt.setInt(1, quantity);
        pstmt.setString(2, userId);
        pstmt.setString(3, productId);
        int rowsAffected = pstmt.executeUpdate();

        if (rowsAffected > 0) {
            out.println("<p>Product quantity updated successfully.</p>");
        } else {
            out.println("<p style='color: red;'>Product not found in your cart.</p>");
        }
    } catch (Exception e) {
        out.println("<p style='color: red;'>Error: " + e.getMessage() + "</p>");
    } finally {
        try {
            if (pstmt != null) pstmt.close();
            if (conn != null) conn.close();
        } catch (SQLException ignored) {}
    }

    // Redirect back to the cart
    response.sendRedirect("showcart.jsp");
%>
</body>
</html>
