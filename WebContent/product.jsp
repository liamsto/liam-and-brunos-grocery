<%@ page import="java.sql.*,java.net.URLEncoder" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.math.BigDecimal" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Liam's Grocery - Product Information</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 20px;
            background-color: #f0f0f0;
        }
        .container {
            max-width: 800px;
            margin: 0 auto;
            padding: 20px;
            background-color: #ffffff;
            border-radius: 8px;
            box-shadow: 0px 0px 15px rgba(0, 0, 0, 0.1);
        }
        h1 {
            text-align: center;
        }
        .product-image {
            text-align: center;
            margin-bottom: 20px;
        }
        .product-details {
            text-align: center;
            margin-bottom: 20px;
        }
        .actions {
            text-align: center;
            margin-top: 20px;
        }
        a {
            text-decoration: none;
            color: #fff;
            background-color: #007bff;
            padding: 10px 20px;
            border-radius: 5px;
            transition: background-color 0.3s;
        }
        a:hover {
            background-color: #0056b3;
        }
        .review-section {
            margin-top: 40px;
        }
        .review {
            background-color: #f9f9f9;
            margin: 15px 0;
            padding: 15px;
            border-radius: 5px;
        }
        .review p {
            margin: 5px 0;
        }
        hr {
            border: none;
            border-top: 1px solid #ddd;
            margin-top: 15px;
            margin-bottom: 15px;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>Product Information</h1>
        <%
        String productId = request.getParameter("productId");
        if (productId == null || productId.isEmpty()) {
            out.println("<p style='color: red;'>Invalid product ID.</p>");
            return;
        }

        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
            String url = "jdbc:sqlserver://cosc304_sqlserver:1433;DatabaseName=orders;TrustServerCertificate=True";
            String dbUser = "sa";
            String dbPassword = "304#sa#pw";
            conn = DriverManager.getConnection(url, dbUser, dbPassword);

            String query = "SELECT productName, productPrice, productDesc, productImageURL FROM product WHERE productId = ?";
            pstmt = conn.prepareStatement(query);
            pstmt.setInt(1, Integer.parseInt(productId));
            rs = pstmt.executeQuery();

            if (rs.next()) {
                String productName = rs.getString("productName");
                BigDecimal productPrice = rs.getBigDecimal("productPrice");
                String productDesc = rs.getString("productDesc");
                String productImageURL = rs.getString("productImageURL");

                out.println("<div class='product-details'>");
                out.println("<h2>" + productName + "</h2>");
                out.println("<p>Price: " + NumberFormat.getCurrencyInstance().format(productPrice) + "</p>");
                out.println("<p>Description: " + productDesc + "</p>");
                out.println("</div>");

                if (productImageURL != null && !productImageURL.isEmpty()) {
                    out.println("<div class='product-image'><img src='" + productImageURL + "' alt='Product Image' width='300'></div>");
                }
                // Display image from database
                out.println("<div class='product-image'><img src='displayImage.jsp?productId=" + productId + "' alt='Product Image from Database' width='300'></div>");

                String addCartLink = "addcart.jsp?id=" + productId + "&name=" + URLEncoder.encode(productName, "UTF-8") + "&price=" + productPrice;
                out.println("<div class='actions'>");
                out.println("<a href='" + addCartLink + "'>Add to Cart</a>");
                out.println("<a href='listprod.jsp' style='margin-left: 20px;'>Continue Shopping</a>");
                out.println("<a href='createReview.jsp?productId=" + productId + "' style='margin-left: 20px;'>Leave a Review!</a>");
                out.println("</div>");

                // Close product result set and statement before fetching reviews
                rs.close();
                pstmt.close();

                // Retrieve reviews for the product
                out.println("<div class='review-section'>");
                out.println("<h2>Customer Reviews</h2>");

                String reviewQuery = "SELECT reviewRating, reviewDate, reviewComment FROM review WHERE productId = ? ORDER BY reviewDate DESC";
                pstmt = conn.prepareStatement(reviewQuery);
                pstmt.setInt(1, Integer.parseInt(productId));
                rs = pstmt.executeQuery();

                boolean hasReviews = false;
                while (rs.next()) {
                    hasReviews = true;
                    int reviewRating = rs.getInt("reviewRating");
                    Timestamp reviewDate = rs.getTimestamp("reviewDate");
                    String reviewCmt = rs.getString("reviewComment");

                    out.println("<div class='review'>");
                    out.println("<p><strong>Rating:</strong> " + reviewRating + "/5</p>");
                    out.println("<p><strong>Date:</strong> " + reviewDate + "</p>");
                    out.println("<p><strong>Comment:</strong> " + reviewCmt + "</p>");
                    out.println("</div>");
                    out.println("<hr/>");
                }

                if (!hasReviews) {
                    out.println("<p>No reviews yet. Be the first to <a href='createReview.jsp?productId=" + productId + "'>leave a review</a>.</p>");
                }

                out.println("</div>");

            } else {
                out.println("<p style='color: red;'>Product not found.</p>");
            }
        } catch (ClassNotFoundException e) {
            out.println("<p style='color: red;'>Error loading database driver: " + e.getMessage() + "</p>");
        } catch (SQLException e) {
            out.println("<p style='color: red;'>SQL Error: " + e.getMessage() + "</p>");
        } finally {
            if (rs != null) try { rs.close(); } catch (SQLException ignored) {}
            if (pstmt != null) try { pstmt.close(); } catch (SQLException ignored) {}
            if (conn != null) try { conn.close(); } catch (SQLException ignored) {}
        }
        %>
    </div>
</body>
</html>
