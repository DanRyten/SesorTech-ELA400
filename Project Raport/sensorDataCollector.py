import time
import math
import board
import busio
import adafruit_lsm6dso

# Filterinställningar
alpha = 0.98  # Filterkoefficient
dt = 0.1      # Samplingtid (sekunder)

gyro_pitch = 0.0
gyro_roll = 0.0
filtered_pitch = 0.0
filtered_roll = 0.0
first_row = True

# Initiera I2C och sensor
i2c = busio.I2C(board.SCL, board.SDA)
sensor = adafruit_lsm6dso.LSM6DSO(i2c)

while True:
    # 1. Läs data från sensor
    accel_x, accel_y, accel_z = sensor.acceleration  # i m/s²
    gyro_x, gyro_y, gyro_z = sensor.gyro             # i °/s

    # 2. Beräkna accelerometerbaserad pitch och roll
    accel_pitch = math.atan2(accel_x, math.sqrt(accel_y**2 + accel_z**2))
    accel_roll  = math.atan2(accel_y, math.sqrt(accel_x**2 + accel_z**2))

    # 3. Konvertera gyro från grader/s till radianer/s
    gyro_x_rad = math.radians(gyro_x)
    gyro_y_rad = math.radians(gyro_y)

    if first_loop:
        # Initiera filtrerat värde från accelerometern första gången
        filtered_pitch = accel_pitch
        filtered_roll = accel_roll
        first_loop = False
    else:
        # 4. Integrera gyrot
        gyro_pitch = filtered_pitch + gyro_x_rad * dt
        gyro_roll = filtered_roll + gyro_y_rad * dt

        # 5. Komplementärt filter
        filtered_pitch = alpha * gyro_pitch + (1 - alpha) * accel_pitch
        filtered_roll = alpha * gyro_roll + (1 - alpha) * accel_roll

    # 6. Konvertera till grader för utskrift
    filtered_pitch_deg = math.degrees(filtered_pitch)
    filtered_roll_deg = math.degrees(filtered_roll)

    print(f"Filtrerad pitch: {filtered_pitch_deg:.2f}°, roll: {filtered_roll_deg:.2f}°")
    print("-" * 40)

    time.sleep(dt)  # Vänta på nästa mätning
