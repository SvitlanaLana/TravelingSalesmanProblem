import re
import numpy as np

#problems = ['br17', 'ft53',  'ftv33', 'ftv35', 'ftv44', 'ftv47', 'ftv55', 'ftv64',   'p43',  'ry48p']
problems = ['swiss42']
if __name__ == "__main__":
    for problem_name in problems:
    	with open('%s.tsp' % problem_name, 'rw') as f:
    		text = re.sub(r'(\d)\n ', '\\1\t',f.read())
    		dimensions = int(re.search(r'DIMENSION: +(\d+)\n', text).group(1))
    		data = re.search(r"EDGE_WEIGHT_SECTION\n((.| |\n)*)EOF", text).group(1)
    		array1d = np.fromstring(data, dtype=int, sep = ' ')
    		array = array1d.reshape(dimensions, dimensions)
    		np.savetxt('%s_fixed.atsp' % problem_name, array, fmt='%d')
