package model;

import java.sql.Date;

public class Appointment {
    private int id;
    private String customerUsername;
    private String customerName;
    private String customerPhone;
    private String doctorUsername;
    private String doctorName; // display helper
    private Date appointmentDate;
    private String timeSlot;
    private String status;
    private String symptoms;
    private String diagnosis;
    private String assignedRoom;

    public Appointment() {}

    public Appointment(int id, String customerUsername, String customerName, String customerPhone, String doctorUsername, Date appointmentDate, String timeSlot, String status, String symptoms, String diagnosis, String assignedRoom) {
        this.id = id;
        this.customerUsername = customerUsername;
        this.customerName = customerName;
        this.customerPhone = customerPhone;
        this.doctorUsername = doctorUsername;
        this.appointmentDate = appointmentDate;
        this.timeSlot = timeSlot;
        this.status = status;
        this.symptoms = symptoms;
        this.diagnosis = diagnosis;
        this.assignedRoom = assignedRoom;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getCustomerUsername() { return customerUsername; }
    public void setCustomerUsername(String customerUsername) { this.customerUsername = customerUsername; }

    public String getCustomerName() { return customerName; }
    public void setCustomerName(String customerName) { this.customerName = customerName; }

    public String getCustomerPhone() { return customerPhone; }
    public void setCustomerPhone(String customerPhone) { this.customerPhone = customerPhone; }

    public String getDoctorUsername() { return doctorUsername; }
    public void setDoctorUsername(String doctorUsername) { this.doctorUsername = doctorUsername; }

    public String getDoctorName() { return doctorName; }
    public void setDoctorName(String doctorName) { this.doctorName = doctorName; }

    public Date getAppointmentDate() { return appointmentDate; }
    public void setAppointmentDate(Date appointmentDate) { this.appointmentDate = appointmentDate; }

    public String getTimeSlot() { return timeSlot; }
    public void setTimeSlot(String timeSlot) { this.timeSlot = timeSlot; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public String getSymptoms() { return symptoms; }
    public void setSymptoms(String symptoms) { this.symptoms = symptoms; }

    public String getDiagnosis() { return diagnosis; }
    public void setDiagnosis(String diagnosis) { this.diagnosis = diagnosis; }

    public String getAssignedRoom() { return assignedRoom; }
    public void setAssignedRoom(String assignedRoom) { this.assignedRoom = assignedRoom; }
}
