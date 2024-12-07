<%@ page import="java.sql.*" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Map" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Remove Item from Cart</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f0f0f0;
            margin: 20px;
        }
        h1, h2 {
            text-align: center;
        }
        p {
            text-align: center;
            font-size: 1.2em;
        }
        a {
            text-decoration: none;
            color: #fff;
            background-color: #007bff;
            padding: 10px 20px;
            border-radius: 5px;
            transition: background-color 0.3s;
            display: inline-block;
            margin: 10px;
        }
        a:hover {
            background-color: #0056b3;
        }
    </style>
</head>
<body>
<%
    String productId = request.getParameter("productId");
    String userId = (String) session.getAttribute("authenticatedUser"); // Get the logged-in user ID

    if (userId == null) {
        out.println("<p>You must be logged in to modify your cart.</p>");
    } else if (productId == null || productId.isEmpty()) {
        out.println("<p>Invalid product ID.</p>");
    } else {
        // Remove from database cart
        Connection conn = null;
        PreparedStatement pstmt = null;

        try {
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
            String url = "jdbc:sqlserver://cosc304_sqlserver:1433;DatabaseName=orders;TrustServerCertificate=True";
            String dbUser = "sa";
            String dbPassword = "304#sa#pw";
            conn = DriverManager.getConnection(url, dbUser, dbPassword);

            // Delete the item from the database cart
            String deleteQuery = "DELETE FROM cart WHERE userId = ? AND productId = ?";
            pstmt = conn.prepareStatement(deleteQuery);
            pstmt.setString(1, userId);
            pstmt.setString(2, productId);
            int rowsAffected = pstmt.executeUpdate();

            if (rowsAffected > 0) {
                out.println("<p>Product with ID " + productId + " has been removed from your shopping cart.</p>");
            } else {
                out.println("<p>Product with ID " + productId + " was not found in your cart.</p>");
            }
        } catch (Exception e) {
            out.println("<p style='color: red;'>Error: " + e.getMessage() + "</p>");
        } finally {
            try {
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (SQLException ignored) {}
        }

        
        @SuppressWarnings({"unchecked"})
        HashMap<String, ArrayList<Object>> productList = (HashMap<String, ArrayList<Object>>) session.getAttribute("productList");
        if (productList != null && productList.containsKey(productId)) {
            productList.remove(productId);
            session.setAttribute("productList", productList);
        }
    }
%>

<h2><a href="showcart.jsp">Back to Cart</a></h2>
<h2><a href="listprod.jsp">Continue Shopping</a></h2>
</body>
</html>
