#!/bin/bash

calib_result="/userdata/CarryBoy/NAV/vision_program_and_extrinsic_calibration/ExtCalibrator/calib_result.txt"
config_json="/userdata/CarryBoy/NAV/visloc/config/camera.json"

if [ -f "$calib_result" ] && [ -f "$config_json" ]; then
    echo "步骤1：读取calib_result.txt文件内容"
    K=$(grep -oP 'K: \[\K[^]]+' $calib_result)
    D=$(grep -oP 'D: \[\K[^]]+' $calib_result)
    E=$(grep -oP 'E: \[\K[^]]+' $calib_result)

    if [ -n "$K" ] && [ -n "$D" ] && [ -n "$E" ]; then
        echo "步骤2：替换camera.json中的internal_param、distortion_param和external_param字段"
        sed -i "s|\"internal_param\":\[[^]]*\]|\"internal_param\":[$K]|" $config_json
        sed -i "s|\"distortion_param\":\[[^]]*\]|\"distortion_param\":[$D]|" $config_json
        sed -i "s|\"external_param\":\[[^]]*\]|\"external_param\":[$E]|" $config_json
        echo "成功：已更新camera.json文件"
    else
        echo "错误：未找到有效的内参、畸变参数或外参数据"
        exit 1
    fi
else
    echo "错误：缺少calib_result.txt或camera.json文件"
    exit 1
fi

