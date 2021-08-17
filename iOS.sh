#######################################
#     iOS Script for React-Native     #
# Created by IRONKAGE (Oleh Hatsenko) #
#            Ukraine  2021            #
#######################################

# Clear arguments
unset $(grep -v '^#' $ENVFILE | sed -E 's/(.*)=.*/\1/' | xargs)

# Create new arguments from ENVFILE
eval $(grep -v -e '^#' $ENVFILE | xargs -I {} echo export \'{}\')

# Before run this script → Shutdown: Metro-server
iOSname=${iOSname// /-}
xcrun simctl shutdown $iOSname || true
sleep 5
if [[ $(xcrun simctl list | grep -w "$iOSname" | grep -w "Shutdown") =~ Shutdown ]];
then
  echo "📱 iOS Simulator to be exist"
  xcrun simctl boot $iOSname
else
  echo "🔎 Simulator not exist! \n📟 Create Simulator"
  version=${iOSversion/./-}
  type=${iOSdevice// /-}
  type=${type//'('/-}
  type=${type//')'/-}
  type=${type//./-}
  if xcrun simctl create $iOSname com.apple.CoreSimulator.SimDeviceType.$type com.apple.CoreSimulator.SimRuntime.iOS-$version;
  then
    echo "Great 🎉"
    xcrun simctl boot $iOSname
  else
    echo "📵 Not correct data"
    echo "Please to Run → xcrun simctl list"
  fi
fi
