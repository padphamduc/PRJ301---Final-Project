package model;

public class Prescription {
    private int appointmentId;
    private int medicineId;
    private String medicineName; // display helper
    private double medicinePrice; // display helper
    private String medicineUnit; // display helper
    private int quantity;
    private int boughtQuantity;
    private String instructions;

    public Prescription() {}

    public Prescription(int appointmentId, int medicineId, String medicineName, double medicinePrice, String medicineUnit, int quantity, int boughtQuantity, String instructions) {
        this.appointmentId = appointmentId;
        this.medicineId = medicineId;
        this.medicineName = medicineName;
        this.medicinePrice = medicinePrice;
        this.medicineUnit = medicineUnit;
        this.quantity = quantity;
        this.boughtQuantity = boughtQuantity;
        this.instructions = instructions;
    }

    public int getAppointmentId() { return appointmentId; }
    public void setAppointmentId(int appointmentId) { this.appointmentId = appointmentId; }

    public int getMedicineId() { return medicineId; }
    public void setMedicineId(int medicineId) { this.medicineId = medicineId; }

    public String getMedicineName() { return medicineName; }
    public void setMedicineName(String medicineName) { this.medicineName = medicineName; }

    public double getMedicinePrice() { return medicinePrice; }
    public void setMedicinePrice(double medicinePrice) { this.medicinePrice = medicinePrice; }

    public String getMedicineUnit() { return medicineUnit; }
    public void setMedicineUnit(String medicineUnit) { this.medicineUnit = medicineUnit; }

    public int getQuantity() { return quantity; }
    public void setQuantity(int quantity) { this.quantity = quantity; }

    public int getBoughtQuantity() { return boughtQuantity; }
    public void setBoughtQuantity(int boughtQuantity) { this.boughtQuantity = boughtQuantity; }

    public String getInstructions() { return instructions; }
    public void setInstructions(String instructions) { this.instructions = instructions; }
}
