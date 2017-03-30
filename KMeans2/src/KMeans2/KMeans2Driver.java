
package KMeans2;

import java.io.IOException;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.conf.Configuration;
import org.apache.hadoop.fs.Path;
import org.apache.hadoop.io.IntWritable;
import org.apache.hadoop.mapreduce.Job;
import org.apache.hadoop.mapreduce.lib.input.FileInputFormat;
import org.apache.hadoop.mapreduce.lib.output.FileOutputFormat;

import org.apache.hadoop.util.GenericOptionsParser;

public class KMeans2Driver {
        
    public static void main(String[] args) throws IOException, InterruptedException, ClassNotFoundException {
        
        Configuration conf = new Configuration();
        String[] otherArgs = new GenericOptionsParser(conf, args).getRemainingArgs();
        if(otherArgs.length != 2) {
            System.err.println("Enter Input and Output Arguments");
            System.exit(1);
        }
        int iteration = 1;
        
        Path dataPath = new Path("/Stuff/Courses/Projects/MapReduce/KMeansData/data");
        Path centroidPath = new Path("/Stuff/Courses/Projects/MapReduce/KMeansData/centroids/centroids.txt");
        conf.set("centroid.path", centroidPath.toString());
        Path outPath = new Path("/Stuff/Courses/Projects/MapReduce/KMeansData/op1");
        Job job = new Job(conf, "KMeans");
        
        job.setJarByClass(KMeans2Driver.class);
        job.setMapperClass(KMeans2Mapper.class);
        job.setReducerClass(KMeans2Reducer.class);
        
        FileInputFormat.addInputPath(job, dataPath);
        FileOutputFormat.setOutputPath(job, outPath);
        
        job.setMapOutputKeyClass(IntWritable.class);
        job.setMapOutputValueClass(Text.class);
        job.setOutputKeyClass(IntWritable.class);
        job.setOutputValueClass(Text.class);
        
        job.waitForCompletion(true);
        
        long counter = job.getCounters().findCounter(KMeans2Reducer.Counter.COUNTER).getValue();
        iteration++;
        while(counter > 0) {
            
            conf = new Configuration();
            dataPath = new Path("/Stuff/Courses/Projects/MapReduce/KMeansData/op" + (iteration - 1));
            conf.set("centroid.path", centroidPath.toString());
            job = Job.getInstance(conf);
            outPath = new Path("/Stuff/Courses/Projects/MapReduce/KMeansData/op" + iteration);
            job.setJobName("KMeans" + iteration);
            
            job.setJarByClass(KMeans2Driver.class);
            job.setMapperClass(KMeans2Mapper.class);
            job.setReducerClass(KMeans2Reducer.class);
            
            FileInputFormat.addInputPath(job, dataPath);
            FileOutputFormat.setOutputPath(job, outPath);
            
            job.waitForCompletion(true);
            iteration++;
            counter = job.getCounters().findCounter(KMeans2Reducer.Counter.COUNTER).getValue();            
        }
        
    }
    
}
