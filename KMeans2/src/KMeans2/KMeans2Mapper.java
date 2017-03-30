
package KMeans2;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStreamReader;
import java.util.ArrayList;
import java.util.List;
import java.util.Scanner;
import org.apache.hadoop.conf.Configuration;
import org.apache.hadoop.fs.FileSystem;
import org.apache.hadoop.fs.Path;
import org.apache.hadoop.io.IntWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Mapper;

public class KMeans2Mapper extends Mapper<Object, Text, IntWritable, Text> {
    
    List<double[]> centroids = new ArrayList<>();
    private final IntWritable centroidIndex = new IntWritable();
    private final Text outPoint = new Text();
    
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
            centroids.add(cent);
        }
    }
    
    @Override
    public void map(Object key, Text value, Context context) throws IOException, InterruptedException {
        
        String line = value.toString().split("\t")[1];
        String[] stringPoints = line.split(",");
        double[] point = new double[stringPoints.length];
        int count = 0;
        double tempDist = Double.MAX_VALUE;
        int belongsToCentroid = 0;
        
        for (int i = 0; i < stringPoints.length ; i++) {
            point[i] = Double.parseDouble(stringPoints[i]);
        }
        
        for (double[] centroid : centroids) {
            
            count++;
            double eucDist = euclidianDistance(point, centroid);
            if(eucDist < tempDist) {
                tempDist = eucDist;
                belongsToCentroid = count;
            }
        }
        
        centroidIndex.set(belongsToCentroid);
        outPoint.set(line);
        
        context.write(centroidIndex, outPoint);        
    }
    
    
    private double euclidianDistance(double[] set1, double[] set2) {
        
        double sum = 0;
        for (int i = 0; i < set1.length; i++) {
            double diff = set1[i] - set2[i];
            sum += diff * diff;
        }
        
        return Math.sqrt(sum);        
    }
}
