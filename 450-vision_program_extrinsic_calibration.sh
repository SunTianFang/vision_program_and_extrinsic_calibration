#!/bin/bash
set -e # 如果命令失败，则退出脚本

# 步骤1
jpg_count=$(ls /userdata/CarryBoy/NAV/ImgRecord/*.jpg 2>/dev/null | wc -l)
if [ $jpg_count -gt 150 ] && [ -f "/userdata/CarryBoy/NAV/ImgRecord/LaserMsg.json" ]; then
    echo "步骤1：图片数量和要求符合条件，开始处理..."
    mkdir -p /userdata/CarryBoy/NAV/ImgRecord/images
    mv /userdata/CarryBoy/NAV/ImgRecord/*.jpg /userdata/CarryBoy/NAV/ImgRecord/images/
    echo "步骤1：.jpg图片已经移动到images文件夹中"
elif [ ! -f "/userdata/CarryBoy/NAV/ImgRecord/*.jpg" ] && [ -f "/userdata/CarryBoy/NAV/ImgRecord/LaserMsg.json" ] && [ -d "/userdata/CarryBoy/NAV/ImgRecord/images" ]; then
    echo "已经存在images文件夹和LaserMsg.json直接进行步骤2"
else
    echo "错误：/userdata/CarryBoy/NAV/ImgRecord/中.jpg图片不足150个或者缺少LaserMsg.json文件"
    exit 1
fi

# 步骤2
#extCalibPath="/userdata/CarryBoy/NAV/ExtCalibrator"
#if [ -d "$extCalibPath" ]; then
#    echo "ExtCalibrator已存在，将被删除"
#    rm -rf $extCalibPath
#fi
#cp -r /userdata/CarryBoy/NAV/vision_program_and_extrinsic_calibration/ExtCalibrator /userdata/CarryBoy/NAV/
#chmod -R 777 /userdata/CarryBoy/NAV/ExtCalibrator
#echo "步骤2：ExtCalibrator文件夹移动并授权完成"

# 步骤3
calib_result="/userdata/CarryBoy/NAV/vision_program_and_extrinsic_calibration/ExtCalibrator/calib_result.txt"
config_json="/userdata/CarryBoy/NAV/vision_program_and_extrinsic_calibration/ExtCalibrator/config.json"
if [ -f "$calib_result" ] && [ -f "$config_json" ]; then
    K=$(grep -oP 'K: \[\K[^\]]+' $calib_result)
    D=$(grep -oP 'D: \[\K[^\]]+' $calib_result)

    sed -i'' "s/\"fx\": [0-9.]*/\"fx\": $(echo ${K%% *})/" $config_json
    sed -i'' "s/\"fy\": [0-9.]*/\"fy\": $(echo $K | cut -d' ' -f2)/" $config_json
    sed -i'' "s/\"cx\": [0-9.]*/\"cx\": $(echo $K | cut -d' ' -f3)/" $config_json
    sed -i'' "s/\"cy\": [0-9.]*/\"cy\": ${K##* }/" $config_json

    # Clear distort values from default_inner
    sed -i'' 's|"distort": \[[^]]*\]|"distort": []|' $config_json

    # Transform the D values into a comma-separated list without brackets or spaces
    D_transformed=$(echo $D | tr ' ' ',' | sed 's/,,/,/g')
    sed -i'' "s|\"distort\": \[]|\"distort\": [$D_transformed]|" $config_json

    ext_values="-0.218 0.028 1.000 90.00 0.0 0.0"
    sed -i'' "s/\"x\": [0-9.-]*/\"x\": $(echo $ext_values | cut -d' ' -f1)/" $config_json
    sed -i'' "s/\"y\": [0-9.-]*/\"y\": $(echo $ext_values | cut -d' ' -f2)/" $config_json
    sed -i'' "s/\"z\": [0-9.-]*/\"z\": $(echo $ext_values | cut -d' ' -f3)/" $config_json
    sed -i'' "s/\"yaw\": [0-9.-]*/\"yaw\": $(echo $ext_values | cut -d' ' -f4)/" $config_json
    sed -i'' "s/\"pitch\": [0-9.-]*/\"pitch\": $(echo $ext_values | cut -d' ' -f5)/" $config_json
    sed -i'' "s/\"roll\": [0-9.-]*/\"roll\": $(echo $ext_values | cut -d' ' -f6)/" $config_json

    # Remove extra commas in default_inner
    sed -i'' 's/,,/,/g' $config_json
else
    echo "缺少calib_result.txt或config.json文件"
fi

# 步骤4
echo "步骤4：执行ext_calibrator可执行文件"
cd /userdata/CarryBoy/NAV/vision_program_and_extrinsic_calibration/ExtCalibrator
./ext_calibrator





