<%@ page import="java.sql.*,java.net.URLEncoder" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.math.BigDecimal" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Liam's Grocery</title>
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
        a {
            text-decoration: none;
            color: #fff;
            background-color: #007bff;
            padding: 5px 10px;
            border-radius: 5px;
            transition: background-color 0.3s;
            font-size: 0.9em;
        }
        a:hover {
            background-color: #0056b3;
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
        }
        .header a:hover {
            text-decoration: underline;
        }
        .message {
            text-align: center;
            font-weight: bold;
            color: green;
            margin: 20px 0;
        }
    </style>
    <script>
        function resetForm() {
            //simple function that resets the form and reloads the page
            const form = document.querySelector('form');
            form.reset();
            window.location.href = window.location.pathname;
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
    // Check for message parameter and display if present
    String message = request.getParameter("message");
    if (message != null && !message.trim().isEmpty()) {
        out.println("<div class='message'>" + message + "</div>");
    }
    %>

    <h1>Search for the products you want to buy:</h1>

    <form method="get" action="listprod.jsp">
        <input type="text" name="productName" size="50" value="<%= request.getParameter("productName") != null ? request.getParameter("productName") : "" %>">
        <select name="categoryId">
            <option value="">All Categories</option>
            <%
            Connection conn = null;
            PreparedStatement pstmt = null;
            ResultSet rsCategories = null;
            try {
                Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
                String url = "jdbc:sqlserver://cosc304_sqlserver:1433;DatabaseName=orders;TrustServerCertificate=True";
                String user = "sa";
                String password = "304#sa#pw";
                conn = DriverManager.getConnection(url, user, password);

                String queryCategories = "SELECT categoryId, categoryName FROM category";
                pstmt = conn.prepareStatement(queryCategories);
                rsCategories = pstmt.executeQuery();

                while (rsCategories.next()) {
                    int categoryId = rsCategories.getInt("categoryId");
                    String categoryName = rsCategories.getString("categoryName");
                    String selected = request.getParameter("categoryId") != null && request.getParameter("categoryId").equals(String.valueOf(categoryId)) ? "selected" : "";
                    out.println("<option value='" + categoryId + "' " + selected + ">" + categoryName + "</option>");
                }
            } catch (ClassNotFoundException e) {
                out.println("<p style='color: red;'>Error loading database driver: " + e.getMessage() + "</p>");
            } catch (SQLException e) {
                out.println("<p style='color: red;'>SQL Error: " + e.getMessage() + "</p>");
            } finally {
                if (rsCategories != null) try { rsCategories.close(); } catch (SQLException ignored) {}
                if (pstmt != null) try { pstmt.close(); } catch (SQLException ignored) {}
                if (conn != null) try { conn.close(); } catch (SQLException ignored) {}
            }
            %>
        </select>
        <input type="submit" value="Submit">
        <input type="reset" value="Reset" onclick="resetForm()"> (Leave blank for all products)
    </form>

    <%
    String name = request.getParameter("productName");
    String categoryId = request.getParameter("categoryId");
    conn = null;
    pstmt = null;
    ResultSet rs = null;
    
    try {
        // Load SQL Server driver
        Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
    
        // Database connection
        String url = "jdbc:sqlserver://cosc304_sqlserver:1433;DatabaseName=orders;TrustServerCertificate=True";
        String usr = "sa";
        String pwd = "304#sa#pw";
        conn = DriverManager.getConnection(url, usr, pwd);
    
        // Query to fetch products with category
        String query = "SELECT p.productId, p.productName, p.productPrice, c.categoryName FROM product p "
                     + "JOIN category c ON p.categoryId = c.categoryId";
        boolean hasCondition = false;
        if (name != null && !name.trim().isEmpty()) {
            query += " WHERE p.productName LIKE ?";
            hasCondition = true;
        }
        if (categoryId != null && !categoryId.trim().isEmpty()) {
            query += hasCondition ? " AND" : " WHERE";
            query += " p.categoryId = ?";
        }
    
        pstmt = conn.prepareStatement(query);
        int paramIndex = 1;
        if (name != null && !name.trim().isEmpty()) {
            pstmt.setString(paramIndex++, "%" + name + "%");
        }
        if (categoryId != null && !categoryId.trim().isEmpty()) {
            pstmt.setInt(paramIndex, Integer.parseInt(categoryId));
        }
    
        rs = pstmt.executeQuery();
    
        // Display products in a table
        out.println("<table>");
        out.println("<tr><th>Product ID</th><th>Product Name</th><th>Price</th><th>Category</th><th>Action</th></tr>");
    
        NumberFormat currFormat = NumberFormat.getCurrencyInstance();
        boolean hasProducts = false;
    
        while (rs.next()) {
            hasProducts = true;
            int productIdVal = rs.getInt("productId");
            String productName = rs.getString("productName");
            BigDecimal productPrice = rs.getBigDecimal("productPrice");
            String categoryName = rs.getString("categoryName");
    
            String productDetailLink = "product.jsp?productId=" + productIdVal;
            String addCartLink = "addcart.jsp?id=" + productIdVal + "&name=" + URLEncoder.encode(productName, "UTF-8") + "&price=" + productPrice;
    
            out.println("<tr>");
            out.println("<td>" + productIdVal + "</td>");
            out.println("<td><a href='" + productDetailLink + "'>" + productName + "</a></td>");
            out.println("<td>" + currFormat.format(productPrice) + "</td>");
            out.println("<td>" + categoryName + "</td>");
            out.println("<td><a href='" + addCartLink + "'>Add to Cart</a></td>");
            out.println("</tr>");
        }
    
        out.println("</table>");
    
        if (!hasProducts) {
            out.println("<p>No products found matching your criteria.</p>");
        }
    
    } catch (ClassNotFoundException e) {
        out.println("<p style='color: red;'>Error loading database driver: " + e.getMessage() + "</p>");
    } catch (SQLException e) {
        out.println("<p style='color: red;'>SQL Error: " + e.getMessage() + "</p>");
    } finally {
        // Close resources
        if (rs != null) try { rs.close(); } catch (SQLException ignored) {}
        if (pstmt != null) try { pstmt.close(); } catch (SQLException ignored) {}
        if (conn != null) try { conn.close(); } catch (SQLException ignored) {}
    }
    %>
    
    <div style="text-align: center; margin-top: 20px;">
        <a href="listprod.jsp" class="action-button">Continue Shopping</a>
    </div>

</body>
</html>
