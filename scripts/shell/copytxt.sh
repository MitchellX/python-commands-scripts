for name in `ls samples`;do
  name=${name%_*}
  cp val_landmark/${name}*.txt samples_landmark/
  echo "cp val_landmark/${name}*.txt samples_landmark/"
done