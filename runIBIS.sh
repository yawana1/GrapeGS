plink="/home/yn259/apps/plink/plink"
ibis="/home/yn259/apps/ibis/ibis"
map="/home/yn259/apps/ibis/add-map-plink.pl"

echo 'Horizon x Rupestris GBS :: IBIS Without MAP'
dir="/media/yn259/data/research/HC"
phy_ibis="$dir/gbs/phy_ibis"
if [ ! -d "$phy_ibis" ]
then
	echo "creating ibis directory"
	mkdir "$phy_ibis"
fi
$plink --vcf $dir/gbs/genotype.vcf --make-bed --out $phy_ibis/genotype
$ibis -bfile $phy_ibis/genotype -ibd2 -t 4 -f $phy_ibis/ibis

echo 'Horizon x Rupestris SNP :: IBIS  Without MAP'
dir="/media/yn259/data/research/HC"
phy_ibis="$dir/snp/phy_ibis"
if [ ! -d "$phy_ibis" ]
then
	echo "creating ibis directory"
	mkdir "$phy_ibis"
fi
$plink --vcf $dir/snp/genotype.vcf --make-bed --vcf-half-call m --out $phy_ibis/genotype
$ibis -bfile $phy_ibis/genotype -ibd2 -t 4 -f $phy_ibis/ibis

echo 'Horizon x Rupestris SNP :: IBIS With MAP'
dir="/media/yn259/data/research/HC"
gen_ibis="$dir/snp/gen_ibis"
if [ ! -d "$gen_ibis" ]
then
	echo "creating ibis directory"
	mkdir "$gen_ibis"
fi
$plink --vcf $dir/snp/genotype.vcf --make-bed --vcf-half-call m --out $gen_ibis/genotype
$map $gen_ibis/genotype.bim $dir/snp/HC_map.txt > $gen_ibis/genotype.bim
$ibis -bfile $gen_ibis/genotype -ibd2 -t 4 -f $gen_ibis/ibis