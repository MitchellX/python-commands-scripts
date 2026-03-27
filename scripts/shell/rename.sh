for name in `ls thin_results_demo_1080/*.png`;do
name=`basename $name`
echo mv thin_results_demo_1080/${name} thin_results_demo_1080/${name:6}
mv thin_results_demo_1080/${name} thin_results_demo_1080/${name:6}
done
