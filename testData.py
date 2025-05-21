import csv
import random

# Antal datapunkter som ska genereras
num_samples = 100

# Gravitationskonstant (för accelerometer) i m/s^2
g = 9.81

# Öppna en CSV-fil för skrivning
with open('finger_testdata.csv', mode='w', newline='') as file:
    writer = csv.writer(file)
    
    # Skriv header
    writer.writerow(['accel_x', 'accel_y', 'accel_z', 'gyro_x', 'gyro_y', 'gyro_z'])
    
    for _ in range(num_samples):
        # Simulera accelerometerdata (x, y, z) runt g i z-led med små variationer (typ böjning)
        accel_x = random.uniform(-2, 2)  # små rörelser i x-led
        accel_y = random.uniform(-2, 2)  # små rörelser i y-led
        accel_z = g + random.uniform(-1, 1)  # runt gravitation i z-led med mindre brus
        
        # Simulera gyroskopdata (rotationshastighet) i grader/s inom rimligt intervall för fingerrörelse
        gyro_x = random.uniform(-90, 90)  # rotation runt x-axeln, fingrets böjning
        gyro_y = random.uniform(-10, 10)  # små rotationer runt y-axeln
        gyro_z = random.uniform(-10, 10)  # små rotationer runt z-axeln
        
        # Skriv raden med data till filen
        writer.writerow([accel_x, accel_y, accel_z, gyro_x, gyro_y, gyro_z])

print("Testdata genererad i 'finger_testdata.csv'")
