
package KMeans2;

import java.io.BufferedWriter;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.OutputStreamWriter;
import java.util.ArrayList;
import java.util.List;
import java.util.Scanner;
import org.apache.hadoop.conf.Configuration;
import org.apache.hadoop.fs.FileSystem;
import org.apache.hadoop.fs.Path;
import org.apache.hadoop.io.IntWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Reducer;

public class KMeans2Reducer extends Reducer<IntWritable, Text, IntWritable, Text> {
    
    List<double[]> oldCentroids = new ArrayList<>();
    int[] sumPoints = new int[4];
    double[] newCentroid = new double[4];
    public static enum Counter {
        COUNTER;
    }
    
    @Override
    public void setup(Context context) throws FileNotFoundException, IOException {
        
        Configuration conf = context.getConfiguration();
        Path centroidPath = new Path(conf.get("centroid.path"));
        FileSystem fs = FileSystem.get(conf);
        Scanner in = new Scanner(fs.open(centroidPath));
        
        while (in.hasNext()) {
            String[] line = in.nextLine().split(",");
            double[] cent = new double[line.length];
            for (int i = 0; i < line.length; i++) {
                cent[i] = Double.parseDouble(line[i]);
            }
            oldCentroids.add(cent);
        }
    }
    
    @Override
    public void reduce(IntWritable key, Iterable<Text> value, Context context) 
            throws IOException, InterruptedException {
        
        int count = 0;
        //int dimensions = oldCentroids.get(1).length;
        
        for (Text val : value) { 
            count++;
            String[] line = val.toString().split(",");
            double[] point = new double[line.length];
            
            for (int i = 0; i < line.length; i++) {
                point[i] = Double.parseDouble(line[i]);
            }
            
            for (int i = 0; i < line.length; i++) {
                sumPoints[i] += point[i];
            }
            context.write(key, val);
        }
        
        for (int i = 0; i < sumPoints.length; i++) {
            newCentroid[i] = sumPoints[i] / count;
        }
        
        if(vectorDifference(newCentroid, oldCentroids.get(key.get())))
            context.getCounter(Counter.COUNTER).increment(1);
    }
    
    @Override
    public void cleanup(Context context) throws IOException {
        
        Configuration conf = context.getConfiguration();
        Path centroidPath = new Path(conf.get("centroid.path"));
        FileSystem fs = FileSystem.get(conf);
        fs.delete(centroidPath, true);
        
        BufferedWriter wr = new BufferedWriter(new OutputStreamWriter(fs.create(centroidPath)));
        
        for (int i = 0; i < newCentroid.length; i++) {
            if (i == newCentroid.length - 1) {
                wr.write(newCentroid[i] + "");
                wr.newLine();
            } else {
                wr.write(newCentroid[i] + ",");
            }
        }
        wr.close();
    }
    
    private boolean vectorDifference(double[] newCent, double[] oldCent) {
        
        int flag = 0;
        for (int i = 0; i < oldCent.length; i++) {            
            if (newCent[i] != oldCent[i]) {
                flag++;
            }
        }
        return flag != 0;       //returns true if centroids have changed
    }
}
