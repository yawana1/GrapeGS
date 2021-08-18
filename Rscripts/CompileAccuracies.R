# basedir = "/home/yaw/Documents/Grape/Horizon_x_Cinerea/rqtl/crossvalidation"
basedir = "/home/yaw/Documents/Grape/Horizon_x_Illinois547-1/rqtl/crossvalidation"
# basedir = "/home/yaw/Documents/Grape/RupestrisB38_x_Horizon/rqtl/crossvalidation"
setwd(basedir)
fileList = list.files(path=basedir, pattern = "acc_*")


df = NULL
for(f in fileList){
  P = read.table(file.path(basedir, f), header=TRUE, sep="\t")
  if(is.null(df)){
    df = P
  }else{
    df = rbind(df, P) 
  }
}
write.table(df, file=file.path(basedir, "accuracy.txt"), row.names=FALSE, col.names=TRUE, sep="\t")