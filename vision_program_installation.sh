#!/bin/bash
set -e # 如果命令失败，则退出脚本
# 定义源目录和目标目录
SOURCE_DIR="/userdata/CarryBoy/NAV/vision_program_and_extrinsic_calibration"  # 源目录路径
DEST_DIR="/userdata/CarryBoy/NAV"  # 目标目录路径
LIB_DIR="/usr/local/lib"  # 存放库文件的目录路径
RECORD_DIR="${DEST_DIR}/ImgRecord"  # 图片记录目录路径

echo "步骤1：准备复制visloc文件夹和SiaLoc_main.sh..."
# 如果目标目录包含visloc文件夹和SiaLoc_main.sh文件，则先全部删除
if [ -d "${DEST_DIR}/visloc" ] || [ -f "${DEST_DIR}/SiaLoc_main.sh" ]; then
  echo "先删除现有的visloc文件夹和SiaLoc_main.sh..."
  sudo rm -rf "${DEST_DIR}/visloc"  # 删除visloc文件夹
  sudo rm -f "${DEST_DIR}/SiaLoc_main.sh"  # 删除SiaLoc_main.sh文件
fi

# 将vision_program_and_extrinsic_calibration文件夹中的visloc文件夹和SiaLoc_main.sh文件拷贝到/userdata/CarryBoy/NAV下
sudo cp -r "${SOURCE_DIR}/visloc" "${DEST_DIR}"  # 复制visloc文件夹到目标目录
sudo cp "${SOURCE_DIR}/SiaLoc_main.sh" "${DEST_DIR}"  # 复制SiaLoc_main.sh脚本到目标目录
echo "步骤1：完成　已经拷贝最新visloc文件夹和SiaLoc_main.sh...."


echo "步骤2：准备复制libRKModule.so和librknnrt.so..."
if [ -f　"${LIB_DIR}/libRKModule.so" ] || [ -f "${LIB_DIR}/librknnrt.so" ]; then  # 检查LIB_DIR目录是否存在libRKModule.so或librknnrt.so文件
  echo "先删除现有的libRKModule.so和librknnrt.so..."
  sudo rm -f "${LIB_DIR}/libRKModule.so" "${LIB_DIR}/librknnrt.so"  # 如果存在，删除已有的libRKModule.so和librknnrt.so文件
fi

sudo cp "${SOURCE_DIR}/libRKModule.so" "${LIB_DIR}"  # 复制libRKModule.so到LIB_DIR目录
sudo cp "${SOURCE_DIR}/librknnrt.so" "${LIB_DIR}"  # 复制librknnrt.so到LIB_DIR目录
sudo chmod 777 "${LIB_DIR}/libRKModule.so" "${LIB_DIR}/librknnrt.so"  # 设置libRKModule.so和librknnrt.so文件权限为777
echo "步骤2：完成. 已经拷贝最新的libRKModule.so和librknnrt.so到/usr/local/lib，并添加权限"

echo "步骤3：准备创建ImgRecord文件夹..."
if [ -d "${RECORD_DIR}" ]; then  # 检查ImgRecord文件夹是否已存在
  echo "先删除现有的ImgRecord文件夹..."
  rm -rf "${RECORD_DIR}"  # 如果存在，删除已有的ImgRecord文件夹
fi

mkdir "${RECORD_DIR}"  # 创建ImgRecord文件夹
sudo chmod -R 777 /userdata/CarryBoy/NAV/ImgRecord  # 设置ImgRecord文件夹、DEST_DIR目录下的源目录权限为777
sudo chmod -R 777 /userdata/CarryBoy/NAV/lib*
sudo chmod -R 777 /userdata/CarryBoy/NAV/visloc

echo "步骤3：完成.已经创建ImgRecord文件夹 并添加权限"

echo "顶视安装成功完成！请重启机器！！！"



