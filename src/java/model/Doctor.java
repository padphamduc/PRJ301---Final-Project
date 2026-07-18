package model;

public class Doctor extends User {
    private String specialty;
    private String room;

    public Doctor() {
        super();
    }

    public Doctor(String username, String password, String fullName, String role, String email, String phone, String specialty, String room) {
        super(username, password, fullName, role, email, phone);
        this.specialty = specialty;
        this.room = room;
    }

    public String getSpecialty() { return specialty; }
    public void setSpecialty(String specialty) { this.specialty = specialty; }

    public String getRoom() { return room; }
    public void setRoom(String room) { this.room = room; }
}
