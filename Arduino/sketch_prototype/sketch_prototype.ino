#include <MPU9250.h>
#include <SoftwareSerial.h>
//------------------------------------------------------------------------------------------------------------------------------------------//
//-------------Only library used externaly is MPU9250 by hideakitai, Source: https://github.com/hideakitai/MPU9250 -------------------------//
//------------------------------------------------------------------------------------------------------------------------------------------//
//Definition of all used classes from said library -----------------------------------------------------------------------------------------//
MPU9250 IMU;
MPU9250Setting setting;
//------------------------------------------------------------------------------------------------------------------------------------------//
//Variables for  acc data//-----------------------------------------------------------------------------------------------------------------//
float ax, ay, az;
//------------------------------------------------------------------------------------------------------------------------------------------//
//*-Setup function calls the initialization function which starts the  wire and serial protocoll and identifies the connected mpu sensor----//
//------------------------------------------------------------------------------------------------------------------------------------------//
void setup() {
  initialization();
}
//-------------------------------------------------------------------------------------------------------------------------------------------//
//**-The Serial and Wire protocoll is initialized and the setup function with the respective address (0x68) for the SCL-SDA communication is-//
//---communicated to the setup function of the IMU library. The imu setting function set technical specifications of the sensor.-------------//
//-------------------------------------------------------------------------------------------------------------------------------------------//
void initialization() {
  Serial.begin(115200);
  Wire.begin();
  IMU.setup(0x68);
  imusetting();
}
//-------------------------------------------------------------------------------------------------------------------------------------------//
//***-No  changes were made to the default settings, only preemptifly programmed in case there might be the need to temper with samplerates--//
//-------------------------------------------------------------------------------------------------------------------------------------------//
void imusetting() {
  setting.accel_fs_sel = ACCEL_FS_SEL::A16G;
  setting.gyro_fs_sel = GYRO_FS_SEL::G2000DPS;
  setting.mag_output_bits = MAG_OUTPUT_BITS::M16BITS;
  setting.fifo_sample_rate = FIFO_SAMPLE_RATE::SMPL_200HZ;
  setting.gyro_fchoice = 0x03;
  setting.gyro_dlpf_cfg = GYRO_DLPF_CFG::DLPF_41HZ;
  setting.accel_fchoice = 0x01;
  setting.accel_dlpf_cfg = ACCEL_DLPF_CFG::DLPF_45HZ;
//-------------------------------------------------------------------------------------------------------------------------------------------//
//----Only thing changed was the VIENNA DECLINATION after a google search the magnetic field was set to +5.08--------------------------------//
//-------------------------------------------------------------------------------------------------------------------------------------------//
  IMU.setMagneticDeclination(+5.08);
  IMU.calibrateMag();
  IMU.calibrateAccelGyro();
}
//------------------------------------------------------------------------------------------------------------------------------------------//
//*-data is continously read from the sensor and transmitted to the serial port-------------------------------------------------------------//
//------------------------------------------------------------------------------------------------------------------------------------------//
void loop() {
  lesen();
  send();
//-------------------------------------------------------------------------------------------------------------------------------------------//
//**-If data is availabe it will be read from the sensor and saved in 3 variables------------------------------------------------------------//
//-------------------------------------------------------------------------------------------------------------------------------------------//
void lesen() {
  if (IMU.update()) {
    ax = IMU.getAccX();
    ay = IMU.getAccY();
    az = IMU.getAccZ();
  }
}
//-------------------------------------------------------------------------------------------------------------------------------------------//
//**-Constantly sends data to the serial port------------------------------------------------------------------------------------------------//
//-------------------------------------------------------------------------------------------------------------------------------------------//
void send(){
  Serial.print(ax,4);
  Serial.print(",");
  Serial.print(ay,4);
  Serial.print(",");
  Serial.println(az,4);
}
