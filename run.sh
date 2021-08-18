for entry in ./drm*
do
  pushd "$entry"
  chmod 755 runAsreml.sh
  ./runAsreml.sh
  popd
done

for entry in ./grm*
do
  pushd "$entry"
  chmod 755 runAsreml.sh
  ./runAsreml.sh
  popd
done