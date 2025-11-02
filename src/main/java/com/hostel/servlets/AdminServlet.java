package com.hostel.servlets;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.hostel.dao.BookingDAO;
import com.hostel.model.Admin;
import com.hostel.model.Booking;

@WebServlet("/admin")
public class AdminServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
        Admin admin = (Admin) request.getSession().getAttribute("admin");
        if (admin == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        // Load actual bookings data for dashboard
        BookingDAO bookingDAO = new BookingDAO();
        // If you want extra info: use getAllBookingsWithDetails()
        List<Booking> bookings = bookingDAO.getAllBookings();

        request.setAttribute("bookings", bookings);

        // TODO: You can also load rooms, students, statistics here for more info
        // Example:
        // RoomDAO roomDAO = new RoomDAO();
        // List<Room> rooms = roomDAO.getAllRooms();
        // request.setAttribute("rooms", rooms);

        request.getRequestDispatcher("admin-dashboard.jsp").forward(request, response);
    }
}
