import csv
import math

# Filterinställningar
alpha = 0.98  # Filterkoefficient
dt = 0.1      # Samplingtid (sekunder)

gyro_pitch = 0.0
gyro_roll = 0.0
filtered_pitch = 0.0
filtered_roll = 0.0
first_row = True

with open("finger_testdata.csv", newline="") as csvfile:
    reader = csv.DictReader(csvfile)
    for row in reader:
        # Sensorvärden
        accel_x = float(row["accel_x"])
        accel_y = float(row["accel_y"])
        accel_z = float(row["accel_z"])
        gyro_x = float(row["gyro_x"])
        gyro_y = float(row["gyro_y"])
        gyro_z = float(row["gyro_z"])

        # Pitch och Roll från accelerometern (i radianer)
        accel_pitch = math.atan2(accel_x, math.sqrt(accel_y**2 + accel_z**2))
        accel_roll  = math.atan2(accel_y, math.sqrt(accel_x**2 + accel_z**2))

        # Konvertera gyrodata till rad/s
        gyro_x_rad = math.radians(gyro_x)
        gyro_y_rad = math.radians(gyro_y)

        if first_row:
            # Initiera filtrerade vinklar från accelerometer
            filtered_pitch = accel_pitch
            filtered_roll  = accel_roll
            first_row = False
        else:
            # Integrera gyrodata
            gyro_pitch = filtered_pitch + gyro_x_rad * dt
            gyro_roll  = filtered_roll + gyro_y_rad * dt

            # Komplementärt filter
            filtered_pitch = alpha * gyro_pitch + (1 - alpha) * accel_pitch
            filtered_roll  = alpha * gyro_roll  + (1 - alpha) * accel_roll

        # Omvandla till grader för utskrift
        accel_pitch_deg = math.degrees(accel_pitch)
        accel_roll_deg  = math.degrees(accel_roll)
        gyro_pitch_deg  = math.degrees(gyro_pitch)
        gyro_roll_deg   = math.degrees(gyro_roll)
        filtered_pitch_deg = math.degrees(filtered_pitch)
        filtered_roll_deg  = math.degrees(filtered_roll)

        print(f"Accelerometer pitch: {accel_pitch_deg:.2f}°, roll: {accel_roll_deg:.2f}°")
        print(f"Gyro-integrerad pitch: {gyro_pitch_deg:.2f}°, roll: {gyro_roll_deg:.2f}°")
        print(f"Filtrerad pitch: {filtered_pitch_deg:.2f}°, roll: {filtered_roll_deg:.2f}°")
        print("-" * 40)
