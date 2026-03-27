for name in `ls templates/*.mp4`;do
name=$(basename $name .mp4)
if [ ! -d templates/$name ];then
echo $name" 1 start"
echo "python image2video_fp.py templates/${name}.mp4 templates/$name"
python image2video_fp.py templates/${name}.mp4 templates/$name
fi

if [ ! -d results/${name}_liudehua ];then
echo "python main.py templates/$name users/liudehua.jpg"
python main.py templates/$name users/liudehua.jpg
echo "python image2video_fp.py results/${name}_liudehua results/${name}_liudehua.mp4 25"
python image2video_fp.py results/${name}_liudehua results/${name}_liudehua.mp4 25
fi
done