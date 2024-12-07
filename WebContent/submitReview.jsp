<%@ page import="java.sql.*" %>
<%
    String rating = request.getParameter("rating");
    String reviewComment = request.getParameter("review");
    String productId = request.getParameter("productId");

    // Validate inputs
    if (rating == null || reviewComment == null || productId == null ||
        rating.isEmpty() || reviewComment.isEmpty() || productId.isEmpty()) {
        response.sendRedirect("product.jsp?message=Invalid%20input");
        return;
    }

    try {
        int ratingValue = Integer.parseInt(rating);
        int productIdValue = Integer.parseInt(productId);

        // Validate rating range
        if (ratingValue < 1 || ratingValue > 5) {
            response.sendRedirect("product.jsp?message=Invalid%20rating%20value");
            return;
        }

        // Retrieve authenticatedUser from session
        String authenticatedUser = (String) session.getAttribute("authenticatedUser");
        if (authenticatedUser == null || authenticatedUser.isEmpty()) {
            response.sendRedirect("login.jsp?message=Please%20log%20in%20to%20leave%20a%20review");
            return;
        }

        // Database connection
        String url = "jdbc:sqlserver://cosc304_sqlserver:1433;DatabaseName=orders;TrustServerCertificate=True";
        String user = "sa";
        String password = "304#sa#pw";

        Connection conn = DriverManager.getConnection(url, user, password);

        // Check if product exists
        String checkProductSql = "SELECT COUNT(*) FROM product WHERE productId = ?";
        PreparedStatement checkStmt = conn.prepareStatement(checkProductSql);
        checkStmt.setInt(1, productIdValue);
        ResultSet rs = checkStmt.executeQuery();
        if (rs.next() && rs.getInt(1) == 0) {
            rs.close();
            checkStmt.close();
            response.sendRedirect("product.jsp?message=Invalid%20product%20ID");
            return;
        }
        rs.close();
        checkStmt.close();

        // Lookup the customerId based on authenticatedUser
        String getCustIdSql = "SELECT customerId FROM customer WHERE userid = ?";
        PreparedStatement getCustStmt = conn.prepareStatement(getCustIdSql);
        getCustStmt.setString(1, authenticatedUser);
        ResultSet custRs = getCustStmt.executeQuery();

        Integer customerId = null;
        if (custRs.next()) {
            customerId = custRs.getInt("customerId");
        }
        custRs.close();
        getCustStmt.close();

        if (customerId == null) {
            response.sendRedirect("login.jsp?message=Invalid%20user");
            return;
        }

        // Insert review
        String sql = "INSERT INTO review (reviewRating, reviewDate, customerId, productId, reviewComment) " +
                     "VALUES (?, GETDATE(), ?, ?, ?)";
        PreparedStatement pstmt = conn.prepareStatement(sql);
        pstmt.setInt(1, ratingValue);
        pstmt.setInt(2, customerId);
        pstmt.setInt(3, productIdValue);
        pstmt.setString(4, reviewComment);

        int rowsInserted = pstmt.executeUpdate();

        pstmt.close();
        conn.close();

        if (rowsInserted > 0) {
            response.sendRedirect("product.jsp?message=Thank%20you%20for%20your%20review!");
        } else {
            response.sendRedirect("product.jsp?message=Failed%20to%20submit%20your%20review.");
        }
    } catch (NumberFormatException e) {
        response.sendRedirect("product.jsp?message=Invalid%20rating%20or%20product%20ID");
    } catch (Exception e) {
        e.printStackTrace();
        response.sendRedirect("product.jsp?message=An%20error%20occurred:%20" + e.getMessage());
    }
%>
